  { stdenv, fetchFromGitHub , xorg, freetype, alsaLib, curl, libjack2
  , lv2, pkgconfig, mesa }:

  stdenv.mkDerivation rec {
  version = "0.9.0";
  name = "helm-${version}";

  src = fetchFromGitHub {
    owner = "mtytel";
    repo = "helm";
    rev = "927d2ed27f71a735c3ff2a1226ce3129d1544e7e";
    sha256 = "17ys2vvhncx9i3ydg3xwgz1d3gqv4yr5mqi7vr0i0ca6nad6x3d4";
  };

  buildInputs = [
    xorg.libX11 xorg.libXcomposite xorg.libXcursor xorg.libXext
    xorg.libXinerama xorg.libXrender xorg.libXrandr
    freetype alsaLib curl libjack2 pkgconfig mesa lv2
  ];

  CXXFLAGS = "-DHAVE_LROUND";

  patchPhase = ''
    sed -i 's|usr/||g' Makefile
  '';

  buildPhase = ''
    make lv2
    make standalone
  '';

  installPhase = ''
   make DESTDIR="$out" install
  '';

  meta = with stdenv.lib; {
    homepage = http://tytel.org/helm;
    description = "A free, cross-platform, polyphonic synthesizer";
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
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
  };
}
