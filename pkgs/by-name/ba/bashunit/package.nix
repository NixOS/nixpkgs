{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  bash,
  bc,
  gitMinimal,
  gnugrep,
  jq,
  which,
  writableTmpDirAsHomeHook,
  versionCheckHook,
  coreutils,
  makeBinaryWrapper,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "bashunit";
  version = "0.39.1";

  src = fetchFromGitHub {
    owner = "TypedDevs";
    repo = "bashunit";
    tag = finalAttrs.version;
    hash = "sha256-yMzi2SFEMSNNFztapWavMmbueWwVK0GWjyFR3cJZmTg=";
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
  nativeCheckInputs = [
    bc
    gitMinimal
    jq
    which
  ];
  checkPhase = ''
    runHook preCheck
    patchShebangs bin/bashunit
  ''
  # Disabling a failing test on Darwin platforms only
  + lib.optionalString stdenvNoCC.hostPlatform.isDarwin ''
    rm tests/unit/console_results_test.sh
  ''
  + ''
    make test
    runHook postCheck
  '';

  postFixup = ''
    wrapProgram $out/bin/bashunit \
      --prefix PATH : "${
        lib.makeBinPath [
          coreutils # cat, mktemp
          gnugrep # grep
          which
        ]
      }"
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  doInstallCheck = true;
  versionCheckKeepEnvironment = [
    "HOME"
  ];

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
