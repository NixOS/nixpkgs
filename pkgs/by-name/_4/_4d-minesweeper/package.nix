{
  lib,
  fetchFromGitHub,
  stdenv,
  unzip,
  alsa-lib,
  gcc-unwrapped,
  git,
  godot3-export-templates,
  godot3-headless,
  libGLU,
  libX11,
  libXcursor,
  libXext,
  libXfixes,
  libXi,
  libXinerama,
  libXrandr,
  libXrender,
  libglvnd,
  libpulseaudio,
  zlib,
}:

stdenv.mkDerivation {
  pname = "4d-minesweeper";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "gapophustu";
    repo = "4D-Minesweeper";
    rev = "db176d8aa5981a597bbae6a1a74aeebf0f376df4";
    hash = "sha256-A5QKqCo9TTdzmK13WRSAfkrkeUqHc4yQCzy4ZZ9uX2M=";
  };

  nativeBuildInputs = [
    godot3-headless
    unzip
  ];

  buildInputs = [
    alsa-lib
    gcc-unwrapped.lib
    git
    libGLU
    libX11
    libXcursor
    libXext
    libXfixes
    libXi
    libXinerama
    libXrandr
    libXrender
    libglvnd
    libpulseaudio
    zlib
  ];

  buildPhase = ''
    runHook preBuild

    # Cannot create file '/homeless-shelter/.config/godot/projects/...'
    export HOME=$TMPDIR

    # Link the export-templates to the expected location. The --export commands
    # expects the template-file at .../templates/3.2.3.stable/linux_x11_64_release
    # with 3.2.3 being the version of godot.
    mkdir -p $HOME/.local/share/godot
    ln -s ${godot3-export-templates}/share/godot/templates $HOME/.local/share/godot

    mkdir -p $out/bin/
    cd source/
    godot3-headless --export "Linux/X11" $out/bin/4d-minesweeper

    runHook postBuild
  '';

  dontInstall = true;
  dontFixup = true;
  dontStrip = true;

  meta = with lib; {
    homepage = "https://github.com/gapophustu/4D-Minesweeper";
    description = "4D Minesweeper game written in Godot";
    license = licenses.mpl20;
    platforms = platforms.linux;
    maintainers = [ ];
    mainProgram = "4d-minesweeper";
  };
}
