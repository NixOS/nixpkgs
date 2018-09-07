{ stdenv, fetchFromGitHub, alsaLib, fftwSinglePrec, freetype, libjack2
, pkgconfig, premake3, xorg, ladspa-sdk }:

stdenv.mkDerivation rec {
  name = "distrho-ports-${version}";
  version = "2018-04-16";

  src = fetchFromGitHub {
    owner = "DISTRHO";
    repo = "DISTRHO-Ports";
    rev = version;
    sha256 = "0l4zwl4mli8jzch32a1fh7c88r9q17xnkxsdw17ds5hadnxlk12v";
  };

  patchPhase = ''
    sed -e "s#@./scripts#sh scripts#" -i Makefile
  '';

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    alsaLib fftwSinglePrec freetype libjack2 premake3
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
      Dexed drowaudio-distortion drowaudio-distortionshaper drowaudio-flanger
      drowaudio-reverb drowaudio-tremolo drumsynth EasySSP eqinox HiReSam
      JuceDemoPlugin KlangFalter LUFSMeter LUFSMeterMulti Luftikus Obxd
      PitchedDelay ReFine StereoSourceSeparation TAL-Dub-3 TAL-Filter
      TAL-Filter-2 TAL-NoiseMaker TAL-Reverb TAL-Reverb-2 TAL-Reverb-3
      TAL-Vocoder-2 TheFunction ThePilgrim Vex Wolpertinger
    '';
    license = with licenses; [ gpl2 gpl3 gpl2Plus lgpl3 mit ];
    maintainers = [ maintainers.goibhniu ];
    platforms = [ "x86_64-linux" ];
  };
}
