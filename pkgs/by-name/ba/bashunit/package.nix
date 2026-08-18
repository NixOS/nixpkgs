{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  bashInteractive,
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
  version = "0.44.0";

  src = fetchFromGitHub {
    owner = "TypedDevs";
    repo = "bashunit";
    tag = finalAttrs.version;
    hash = "sha256-5GsSJKgMxzy4tAMtecwF1aopDsXOsOT0KTykHuTGHm4=";
    forceFetchGit = true; # needed to include the tests directory for the check phase
  };

  postPatch = ''
    patchShebangs bashunit build.sh tests
    # Tests emit scripts with #!/usr/bin/env bash at runtime; patch the literals
    substituteInPlace tests/unit/build_test.sh \
      --replace-fail "#!/usr/bin/env bash" "#!${lib.getExe bashInteractive}"
  '';

  nativeBuildInputs = [
    makeBinaryWrapper
    bashInteractive # needed for compgen in checkPhase
  ];

  buildPhase = ''
    runHook preBuild
    ./build.sh
    patchShebangs bin/bashunit
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
    make test/parallel
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
    "PATH"
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
