{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, libX11, glfw, makeWrapper,
  libXrandr, libXinerama, libXcursor, gtk3, ffmpeg-full, ...}:

stdenv.mkDerivation rec {
  pname = "MIDIVisualizer";
  version = "6.2";

  src = fetchFromGitHub {
    owner = "kosua20";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-t7DRPV0FSg6v81GzHLK2O++sfjr2aFT+xg3+wFd0UFg=";
  };

  nativeBuildInputs = [ cmake pkg-config makeWrapper];

  buildInputs = [
    libX11
    glfw
    libXrandr
    libXinerama
    libXcursor
    gtk3
    ffmpeg-full
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp MIDIVisualizer $out/bin

    wrapProgram $out/bin/MIDIVisualizer \
      --prefix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}:$XDG_DATA_DIRS"
  '';

  meta = with lib; {
    description = "A small MIDI visualizer tool, using OpenGL";
    homepage = "https://github.com/kosua20/MIDIVisualizer";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.ericdallo ];
  };
}
