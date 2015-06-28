{ stdenv, fetchgit, alsaLib, fftwSinglePrec, freetype, libjack2
, libxslt, lv2, pkgconfig, premake3, xlibs }:

stdenv.mkDerivation rec {
  name = "distrho-ports-git-2015-05-04";

  src = fetchgit {
    url = "https://github.com/DISTRHO/DISTRHO-Ports.git";
    rev = "3f13db5dc7722ed0dcbb5256d7fac1ac9165c2d8";
    sha256 = "6f740f6a8af714436ef75b858944e8122490a2faa04591a201105e84bca42fa0";
  };

  patchPhase = ''
    sed -e "s#@./scripts#sh scripts#" -i Makefile
  '';

  buildInputs = [
    alsaLib fftwSinglePrec freetype libjack2 pkgconfig premake3
    xlibs.libX11 xlibs.libXcomposite xlibs.libXcursor xlibs.libXext
    xlibs.libXinerama xlibs.libXrender
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
