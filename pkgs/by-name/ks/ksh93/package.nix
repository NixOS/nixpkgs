{
  fetchFromGitHub,
  fixDarwinDylibNames,
  lib,
  stdenv,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "ksh93";
  version = "1.0.10";

  src = fetchFromGitHub {
    owner = "ksh93";
    repo = "ksh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hrXW+PKQ6v0CCKiZ8E3HAEcrt9m4ZO5QfwFT9rCgbxc=";
  };

  patches = [
    ./darwin-install-names.patch
  ];

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    fixDarwinDylibNames
  ];

  buildPhase = ''
    runHook preBuild
    ./bin/package make
    runHook postBuild
  '';

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    ./bin/package test
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall
    ./bin/package install $out
    runHook postInstall
  '';

  passthru = {
    shellPath = "/bin/ksh";
  };

  meta = {
    description = "KornShell 93u+m";
    branch = "1.0";
    homepage = "https://github.com/ksh93/ksh";
    downloadPage = "https://github.com/ksh93/ksh";
    changelog = "https://github.com/ksh93/ksh/blob/${finalAttrs.src.tag}/NEWS";
    license = lib.licenses.epl20;
    maintainers = with lib.maintainers; [ prince213 ];
    mainProgram = "ksh";
    platforms = lib.platforms.unix;
  };
})
