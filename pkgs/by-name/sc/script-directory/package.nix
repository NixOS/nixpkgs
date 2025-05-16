{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installShellFiles,
  patsh,
  coreutils,
}:

stdenvNoCC.mkDerivation rec {
  pname = "script-directory";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "ianthehenry";
    repo = "sd";
    rev = "v${version}";
    hash = "sha256-X5RWCJQUqDnG2umcCk5KS6HQinTJVapBHp6szEmbc4U=";
  };

  nativeBuildInputs = [
    installShellFiles
    patsh
  ];

  # needed for cross
  buildInputs = [ coreutils ];

  installPhase = ''
    runHook preInstall

    patsh -f sd -s ${builtins.storeDir} --path "$HOST_PATH"
    install -Dt "$out/bin" sd
    installShellCompletion --zsh _sd

    runHook postInstall
  '';

  meta = {
    description = "Cozy nest for your scripts";
    homepage = "https://github.com/ianthehenry/sd";
    changelog = "https://github.com/ianthehenry/sd/tree/${src.rev}#changelog";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "sd";
  };
}
