{
  lib,
  stdenv,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mklittlefs";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "earlephilhower";
    repo = "mklittlefs";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-qCL5EG5HyUjObaRReptuNqMKKxOnyP8ZQpOKdLV4F80=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail '$(shell git describe --tag)' '${finalAttrs.version}' \
      --replace-fail '$(shell git -C littlefs describe --tags || echo "unknown")' '2.11.1'

      patchShebangs run_tests.sh
      patchShebangs tests/test_create
  '';

  makeFlags = [
    "BUILD_CONFIG_NAME=-nixos"
  ];

  env = {
    CPPFLAGS =
      "-DLFS_NAME_MAX=255"
      + lib.optionalString stdenv.hostPlatform.isDarwin " -Wno-error=vla-cxx-extension";
  };

  enableParallelBuilding = true;

  doCheck = true;
  checkPhase = ''
     runHook preCheck

    ./run_tests.sh tests

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 mklittlefs -t $out/bin

    runHook postInstall
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Tool to build and unpack littlefs images";
    homepage = "https://github.com/earlephilhower/mklittlefs";
    changelog = "https://github.com/earlephilhower/mklittlefs/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ liberodark ];
    mainProgram = "mklittlefs";
  };
})
