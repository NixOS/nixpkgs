{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, libX11
, glfw
, makeWrapper
, libXrandr
, libXinerama
, libXcursor
, gtk3
, ffmpeg-full
, AppKit
, Carbon
, Cocoa
, CoreAudio
, CoreMIDI
, CoreServices
, Kernel
}:

stdenv.mkDerivation rec {
  pname = "MIDIVisualizer";
  version = "7.0";

  src = fetchFromGitHub {
    owner = "kosua20";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-wfPSPH+E9cErVvfJZqHttFtjiUYJopM/u6w6NpRHifE=";
  };

  nativeBuildInputs = [ cmake pkg-config makeWrapper];

  buildInputs = [
    glfw
    ffmpeg-full
  ] ++ lib.optionals stdenv.isLinux [
    libX11
    libXrandr
    libXinerama
    libXcursor
    gtk3
  ] ++ lib.optionals stdenv.isDarwin [
    AppKit
    Carbon
    Cocoa
    CoreAudio
    CoreMIDI
    CoreServices
    Kernel
  ];

  installPhase = if stdenv.isDarwin then ''
    mkdir -p $out/Applications $out/bin
    cp -r MIDIVisualizer.app $out/Applications/
    ln -s ../Applications/MIDIVisualizer.app/Contents/MacOS/MIDIVisualizer $out/bin/
  '' else ''
    mkdir -p $out/bin
    cp MIDIVisualizer $out/bin

    wrapProgram $out/bin/MIDIVisualizer \
      --prefix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}:$XDG_DATA_DIRS"
  '';

  meta = with lib; {
    description = "Small MIDI visualizer tool, using OpenGL";
    mainProgram = "MIDIVisualizer";
    homepage = "https://github.com/kosua20/MIDIVisualizer";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ maintainers.ericdallo ];
  };
}
