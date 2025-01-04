{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  xorg,
  freetype,
  alsa-lib,
  curl,
  libjack2,
  lv2,
  pkg-config,
  libGLU,
  libGL,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "helm";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "mtytel";
    repo = "helm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pI1umrJGMRBB3ifiWrInG7/Rwn+8j9f8iKkzC/cW2p8=";
  };

  buildInputs = [
    xorg.libX11
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXext
    xorg.libXinerama
    xorg.libXrender
    xorg.libXrandr
    freetype
    alsa-lib
    curl
    libjack2
    libGLU
    libGL
    lv2
  ];
  nativeBuildInputs = [ pkg-config ];

  CXXFLAGS = [
    "-DHAVE_LROUND"
    "-fpermissive"
  ];
  enableParallelBuilding = true;
  makeFlags = [ "DESTDIR=${placeholder "out"}" ];

  patches = [
    # gcc9 compatibility https://github.com/mtytel/helm/pull/233
    (fetchpatch {
      url = "https://github.com/mtytel/helm/commit/cb611a80bd5a36d31bfc31212ebbf79aa86c6f08.patch";
      hash = "sha256-s0eiE5RziZGdInSUOYWR7duvQnFmqf8HO+E7lnVCQsQ=";
    })
  ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail "usr/" ""

    substituteInPlace src/common/load_save.cpp \
      --replace-fail "/usr/share/" "$out/share/"
  '';

  meta = {
    homepage = "https://tytel.org/helm";
    description = "Free, cross-platform, polyphonic synthesizer";
    longDescription = ''
      A free, cross-platform, polyphonic synthesizer.
      Features:
        32 voice polyphony
        Interactive visual interface
        Powerful modulation system with live visual feedback
        Dual oscillators with cross modulation and up to 15 oscillators each
        Unison and Harmony mode for oscillators
        Oscillator feedback and saturation for waveshaping
        12 different waveforms
        7 filter types with keytracking
        2 monophonic and 1 polyphonic LFO
        Step sequencer
        Lots of modulation sources including polyphonic aftertouch
        Simple arpeggiator
        Effects: Formant filter, stutter, delay
    '';
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      magnetophon
      bot-wxt1221
    ];
    platforms = lib.platforms.linux;
    mainProgram = "helm";
  };
})
