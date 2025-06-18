{
  lib,
  python3Packages,
  fetchFromGitHub,
  makeWrapper,
  mpv,
  pulseaudio,
}:

python3Packages.buildPythonApplication rec {
  pname = "cplay-ng";
  version = "5.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "xi";
    repo = "cplay-ng";
    tag = version;
    hash = "sha256-ob5wX+Q5XKB/fTYG5phLU61imonpk2A/fk5cg/dfr1Y=";
  };

  nativeBuildInputs = [ makeWrapper ];

  build-system = [ python3Packages.setuptools ];

  postInstall = ''
    wrapProgram $out/bin/cplay-ng \
      --prefix PATH : ${
        lib.makeBinPath [
          mpv
          pulseaudio
        ]
      }
  '';

  meta = {
    homepage = "https://github.com/xi/cplay-ng";
    description = "Simple curses audio player";
    mainProgram = "cplay-ng";
    longDescription = ''
      cplay is a minimalist music player with a textual user interface written
      in Python. It aims to provide a power-user-friendly interface with simple
      filelist and playlist control.

      Instead of building an elaborate database of your music library, cplay
      allows you to quickly browse the filesystem and enqueue files,
      directories, and playlists.

      The original cplay was started by Ulf Betlehem in 1998 and is no longer
      maintained. This is a rewrite that aims to stay true to the original
      design while evolving with a shifting environment.
    '';
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ fgaz ];
  };
}
