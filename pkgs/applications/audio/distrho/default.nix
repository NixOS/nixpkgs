{ stdenv, fetchgit, alsaLib, fftwSinglePrec, freetype, jackaudio
, libxslt, lv2, pkgconfig, premake, xlibs }:

let
  rev = "7815b3545978e";
in
stdenv.mkDerivation rec {
  name = "distrho-${rev}";

  src = fetchgit {
    url = "git://distrho.git.sf.net/gitroot/distrho/distrho";
    inherit rev;
    sha256 = "2e260f16ee67b1166c39e2d55c8dd5593902c8b3d8d86485545ef83139e1e844";
  };

  patchPhase = ''
    sed -e "s#xsltproc#${libxslt}/bin/xsltproc#" -i Makefile
    sed -e "s#PREFIX = /usr/local#PREFIX = $out#" -i Makefile
    sed -e "s#/etc/HybridReverb2#$out/etc/Hybridreverb2#" \
      -i ports/hybridreverb2/source/SystemConfig.cpp
    sed -e "s#/usr#$out#" -i ports/hybridreverb2/data/HybridReverb2.conf
  '';

  buildInputs = [
    alsaLib fftwSinglePrec freetype jackaudio pkgconfig premake
    xlibs.libX11 xlibs.libXcomposite xlibs.libXcursor xlibs.libXext
    xlibs.libXinerama xlibs.libXrender
  ];

  buildPhase = ''
    sh ./scripts/premake-update.sh linux
    make standalone
    make lv2

    # generate lv2 ttl
    sh scripts/generate-ttl.sh
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp bin/standalone/* $out/bin/
    mkdir -p $out/lib/lv2
    cp -a bin/lv2/* $out/lib/lv2/

    # HybridReverb2 data
    mkdir -p $out/etc/HybridReverb2
    cp ports/hybridreverb2/data/HybridReverb2.conf $out/etc/HybridReverb2/
    mkdir -p $out/share
    cp -a ports/hybridreverb2/data/HybridReverb2 $out/share/
  '';

  meta = with stdenv.lib; {
    homepage = http://distrho.sourceforge.net;
    description = "A collection of cross-platform audio effects and plugins";
    longDescription = ''
      Includes:
      3BandEQ bitmangler drowaudio-distortion drowaudio-flanger
      drowaudio-tremolo eqinox HybridReverb2 juce_pitcher sDelay
      TAL-Filter TAL-NoiseMaker TAL-Reverb-2 TAL-Vocoder-2 ThePilgrim
      Wolpertinger argotlunar capsaicin drowaudio-distortionshaper
      drowaudio-reverb drumsynth highlife JuceDemoPlugin PingPongPan
      TAL-Dub-3 TAL-Filter-2 TAL-Reverb TAL-Reverb-3 TheFunction vex
    '';
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
