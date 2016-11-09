{ stdenv, fetchgit, alsaLib, fftwSinglePrec, freetype, libjack2
, libxslt, lv2, pkgconfig, premake3, xorg, ladspa-sdk }:

stdenv.mkDerivation rec {
  name = "distrho-ports-unstable-2016-06-26";

  src = fetchgit {
    url = "https://github.com/DISTRHO/DISTRHO-Ports.git";
    rev = "e3969853ec9ba897c50ac060f0167313e2a18b29";
    sha256 = "0id4p8dlnlv5271yvmyawfr754nzah7xhvjkj633lw5yr3mq707m";
  };

  patchPhase = ''
    sed -e "s#@./scripts#sh scripts#" -i Makefile
  '';

  buildInputs = [
    alsaLib fftwSinglePrec freetype libjack2 pkgconfig premake3
    xorg.libX11 xorg.libXcomposite xorg.libXcursor xorg.libXext
    xorg.libXinerama xorg.libXrender ladspa-sdk
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
