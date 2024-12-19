{
  runCommand,
  lib,
  makeWrapper,
  fetchFromGitHub,

  git,
  openssh,
  inotify-tools,
}:
runCommand "gitwatch"
  rec {
    version = "0.2";
    src = fetchFromGitHub {
      owner = "gitwatch";
      repo = "gitwatch";
      rev = "v${version}";
      hash = "sha256-KuWD2FAMi2vZ/7e4fIg97DGuAPEV9b9iOuF8NIGFVpE=";
    };
    nativeBuildInputs = [ makeWrapper ];

    meta = {
      description = "Watch a filesystem and automatically stage changes to a git.";
      mainProgram = "gitwatch";
      longDescription = ''
        A bash script to watch a file or folder and commit changes to a git repo.
      '';
      homepage = "https://github.com/gitwatch/gitwatch";
      changelog = "https://github.com/gitwatch/gitwatch/releases/tag/v${version}";
      license = lib.licenses.gpl3Only;
      maintainers = with lib.maintainers; [ shved ];
    };
  }
  ''
    mkdir -p $out/bin
    dest="$out/bin/gitwatch"
    cp "$src/gitwatch.sh" $dest
    chmod +x $dest
    patchShebangs $dest

    wrapProgram $dest \
      --prefix PATH ';' ${
        lib.makeBinPath [
          git
          inotify-tools
          openssh
        ]
      }
  ''
