{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  bash,
  which,
  versionCheckHook,
  coreutils,
  makeBinaryWrapper,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "bashunit";
  version = "0.22.3";

  src = fetchFromGitHub {
    owner = "TypedDevs";
    repo = "bashunit";
    tag = finalAttrs.version;
    hash = "sha256-CN3BmsAFRQSkcS97XkKsL9+lChxb7V05iw8xoq0QVZE=";
    forceFetchGit = true; # needed to include the tests directory for the check phase
  };

  nativeBuildInputs = [ makeBinaryWrapper ];

  postConfigure = ''
    patchShebangs tests build.sh bashunit
    substituteInPlace Makefile \
      --replace-fail "SHELL=/bin/bash" "SHELL=${lib.getExe bash}"
  '';

  buildPhase = ''
    runHook preBuild
    ./build.sh
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -m755 -D bin/bashunit $out/bin/bashunit
    runHook postInstall
  '';

  doCheck = true;
  nativeCheckInputs = [ which ];
  checkPhase = ''
    runHook preCheck
    make test
    runHook postCheck
  '';

  postFixup = ''
    wrapProgram $out/bin/bashunit \
      --prefix PATH : "${
        lib.makeBinPath [
          coreutils
          which
        ]
      }"
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple testing framework for bash scripts";
    homepage = "https://bashunit.typeddevs.com";
    changelog = "https://github.com/TypedDevs/bashunit/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tricktron ];
    mainProgram = "bashunit";
  };
})
