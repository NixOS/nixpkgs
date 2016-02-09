{ stdenv, fetchgit, xorg, freetype, alsaLib, libjack2
, lv2, pkgconfig, mesa }:

stdenv.mkDerivation rec {
  name = "helm-git-2015-09-11";

  src = fetchgit {
    url = "https://github.com/mtytel/helm.git";
    rev = "ad798d4a0a2e7db52e1a7451176ff198a393cdb4";
    sha256 = "0ic4xjikq7s2p53507ykv89844j6sqcd9mh3y59a6wnslr5wq1cw";
  };

  buildInputs = [
    xorg.libX11 xorg.libXcomposite xorg.libXcursor xorg.libXext
    xorg.libXinerama xorg.libXrender xorg.libXrandr
    freetype alsaLib libjack2 pkgconfig mesa lv2
  ];

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/lib/lv2
    cp -a standalone/builds/linux/build/* $out/bin
    cp -a builds/linux/LV2/* $out/lib/lv2/
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
