{ stdenv, fetchgit, alsaLib, fftwSinglePrec, freetype, libjack2
, libxslt, lv2, pkgconfig, premake3, xorg, ladspa-sdk }:

stdenv.mkDerivation rec {
  name = "distrho-ports-unstable-2017-10-10";

  src = fetchgit {
    url = "https://github.com/DISTRHO/DISTRHO-Ports.git";
    rev = "e11e2b204c14b8e370a0bf5beafa5f162fedb8e9";
    sha256 = "1nd542iian9kr2ldaf7fkkgf900ryzqigks999d1jhms6p0amvfv";
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
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
