{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libX11,
  libnotify,
  glfw,
  makeWrapper,
  libXrandr,
  libXinerama,
  libXcursor,
  gtk3,
  ffmpeg-full,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "midivisualizer";
<<<<<<< HEAD
  version = "7.3";
=======
  version = "7.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "kosua20";
    repo = "MIDIVisualizer";
    rev = "v${finalAttrs.version}";
<<<<<<< HEAD
    sha256 = "sha256-ljDdbpvXJXv7YPgxwXELee06NNOwqIBP8C/IbL7qBuk=";
=======
    sha256 = "sha256-Ilsqc14PBTqreLhrEpvMOZAp37xOY/OwuhHTjeOjqm8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    glfw
    ffmpeg-full
    libnotify
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libX11
    libXrandr
    libXinerama
    libXcursor
    gtk3
  ];

  installPhase =
    if stdenv.hostPlatform.isDarwin then
      ''
        mkdir -p $out/Applications $out/bin
        cp -r MIDIVisualizer.app $out/Applications/
        ln -s ../Applications/MIDIVisualizer.app/Contents/MacOS/MIDIVisualizer $out/bin/
      ''
    else
      ''
        mkdir -p $out/bin
        cp MIDIVisualizer $out/bin

        wrapProgram $out/bin/MIDIVisualizer \
          --prefix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}:$XDG_DATA_DIRS"
      '';

<<<<<<< HEAD
  meta = {
    description = "Small MIDI visualizer tool, using OpenGL";
    mainProgram = "MIDIVisualizer";
    homepage = "https://github.com/kosua20/MIDIVisualizer";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isDarwin;
    maintainers = [ lib.maintainers.ericdallo ];
=======
  meta = with lib; {
    description = "Small MIDI visualizer tool, using OpenGL";
    mainProgram = "MIDIVisualizer";
    homepage = "https://github.com/kosua20/MIDIVisualizer";
    license = licenses.mit;
    platforms = platforms.unix;
    broken = stdenv.hostPlatform.isDarwin;
    maintainers = [ maintainers.ericdallo ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
})
