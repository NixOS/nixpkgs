{
  lib,
  gawk,
  gnused,
  gnugrep,
  ncurses,
  coreutils,
  util-linux,
  stdenvNoCC,
  fetchFromGitHub,
  installShellFiles,
  makeWrapper,
}:
stdenvNoCC.mkDerivation {
  pname = "kanban.bash";
  version = "0-unstable-2024-10-17";
  src = fetchFromGitHub {
    owner = "coderofsalvation";
    repo = "kanban.bash";
    rev = "325e2c0c3e75f6bb2106d15107559bc1eea6fd5d";
    hash = "sha256-OE4kKixNG172yMR5vp5O4STq9fGdJVWLIt7j6deNxhI=";
  };
  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];
  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    installShellCompletion --cmd kanban \
      --name kanban.bash --bash kanban.completion
    patchShebangs kanban
    mv kanban $out/bin
    wrapProgram $out/bin/kanban \
      --prefix PATH : ${
        lib.makeBinPath [
          gawk
          gnused
          gnugrep
          ncurses
          util-linux
          coreutils
        ]
      }
    runHook postInstall
  '';
  meta = {
    homepage = "https://github.com/coderofsalvation/kanban.bash";
    platforms = lib.platforms.unix;
    mainProgram = "kanban";
    maintainers = with lib.maintainers; [ phanirithvij ];
  };
}
