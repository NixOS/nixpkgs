{
  runCommand,
  lib,
  makeWrapper,
  fetchFromGitHub,

  coreutils,
  git,
  gnugrep,
  gnused,
  openssh,
  inotify-tools,
}:
runCommand "gitwatch"
  rec {
    version = "0.4";
    src = fetchFromGitHub {
      owner = "gitwatch";
      repo = "gitwatch";
      rev = "v${version}";
      hash = "sha256-DEHhwQvI8i+8ExAQvfY+zL5epmhOkht3a69XOn0cKqY=";
    };
    nativeBuildInputs = [ makeWrapper ];

    meta = {
      description = "Watch a filesystem and automatically stage changes to a git";
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
          coreutils
          git
          gnugrep
          gnused
          inotify-tools
          openssh
        ]
      }
  ''
