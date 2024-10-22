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

stdenv.mkDerivation {
  version = "0.9.0";
  pname = "helm";

  src = fetchFromGitHub {
    owner = "mtytel";
    repo = "helm";
    rev = "927d2ed27f71a735c3ff2a1226ce3129d1544e7e";
    sha256 = "17ys2vvhncx9i3ydg3xwgz1d3gqv4yr5mqi7vr0i0ca6nad6x3d4";
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

  CXXFLAGS = "-DHAVE_LROUND";
  enableParallelBuilding = true;
  makeFlags = [ "DESTDIR=$(out)" ];

  patches = [
    # gcc9 compatibility https://github.com/mtytel/helm/pull/233
    (fetchpatch {
      url = "https://github.com/mtytel/helm/commit/cb611a80bd5a36d31bfc31212ebbf79aa86c6f08.patch";
      sha256 = "1i2289srcfz17c3zzab6f51aznzdj62kk53l4afr32bkjh9s4ixk";
    })
  ];

  prePatch = ''
    sed -i 's|usr/||g' Makefile
    sed -i "s|/usr/share/|$out/share/|" src/common/load_save.cpp
  '';

  meta = with lib; {
    homepage = "http://tytel.org/helm";
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
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
    mainProgram = "helm";
  };
}
