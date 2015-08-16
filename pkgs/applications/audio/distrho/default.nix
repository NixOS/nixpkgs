{ stdenv, fetchgit, alsaLib, fftwSinglePrec, freetype, libjack2
, libxslt, lv2, pkgconfig, premake3, xlibs, ladspa-sdk }:

stdenv.mkDerivation rec {
  name = "distrho-ports-git-2015-07-18";

  src = fetchgit {
    url = "https://github.com/DISTRHO/DISTRHO-Ports.git";
    rev = "53458838505efef91ed069d0a7d970b6b3588eba";
    sha256 = "0fb4dxfvvqy8lnm9c91sxwn5wbcw8grfpm52zag25vrls251aih3";
  };

  patchPhase = ''
    sed -e "s#@./scripts#sh scripts#" -i Makefile
  '';

  buildInputs = [
    alsaLib fftwSinglePrec freetype libjack2 pkgconfig premake3
    xlibs.libX11 xlibs.libXcomposite xlibs.libXcursor xlibs.libXext
    xlibs.libXinerama xlibs.libXrender ladspa-sdk
  ];

  buildPhase = ''
    sh ./scripts/premake-update.sh linux
    make lv2
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/lib/lv2
    cp -a bin/lv2/* $out/lib/lv2/
  '';

  meta = with stdenv.lib; {
    homepage = http://distrho.sourceforge.net;
    description = "A collection of cross-platform audio effects and plugins";
    longDescription = ''
      Includes:
      Dexed  drowaudio-distortion drowaudio-distortionshaper drowaudio-flanger
      drowaudio-reverb drowaudio-tremolo drumsynt EasySSP  eqinox
      JuceDemoPlugin klangfalter LUFSMeter luftikus obxd pitchedDelay
      stereosourceseparation TAL-Dub-3 TAL-Filter TAL-Filter-2 TAL-NoiseMaker
      TAL-Reverb TAL-Reverb-2 TAL-Reverb-3 TAL-Vocoder-2 TheFunction
      ThePilgrim Vex Wolpertinger
    '';
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
