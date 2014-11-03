{ stdenv, fetchgit, alsaLib, fftwSinglePrec, freetype, jack2
, libxslt, lv2, pkgconfig, premake3, xlibs }:

let
  rev = "99efbf0b";
in
stdenv.mkDerivation rec {
  name = "distrho-${rev}";

  src = fetchgit {
    url = "https://github.com/falkTX/DISTRHO.git";
    inherit rev;
    sha256 = "ed26a6edca19ebb8260b3dc042f69c32162e1d91179fb9d22da42ec7131936f9";
  };

  patchPhase = ''
    sed -e "s#@./scripts#sh scripts#" -i Makefile
  '';

  buildInputs = [
    alsaLib fftwSinglePrec freetype jack2 pkgconfig premake3
    xlibs.libX11 xlibs.libXcomposite xlibs.libXcursor xlibs.libXext
    xlibs.libXinerama xlibs.libXrender
  ];

  buildPhase = ''
    sh ./scripts/premake-update.sh linux
    make standalone
    make lv2
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp bin/standalone/* $out/bin/
    mkdir -p $out/lib/lv2
    cp -a bin/lv2/* $out/lib/lv2/
  '';

  meta = with stdenv.lib; {
    homepage = http://distrho.sourceforge.net;
    description = "A collection of cross-platform audio effects and plugins";
    longDescription = ''
      Includes:
      3BandEQ bitmangler drowaudio-distortion drowaudio-flanger
      drowaudio-tremolo eqinox juce_pitcher sDelay TAL-Filter
      TAL-NoiseMaker TAL-Reverb-2 TAL-Vocoder-2 ThePilgrim
      Wolpertinger argotlunar capsaicin drowaudio-distortionshaper
      drowaudio-reverb drumsynth highlife JuceDemoPlugin PingPongPan
      TAL-Dub-3 TAL-Filter-2 TAL-Reverb TAL-Reverb-3 TheFunction vex
    '';
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
