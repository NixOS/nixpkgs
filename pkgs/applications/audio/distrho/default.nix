{ stdenv, fetchgit, alsaLib, fftwSinglePrec, freetype, jack2
, libxslt, lv2, pkgconfig, premake3, xlibs }:

let
  rev = "3bfddf7f";
in
stdenv.mkDerivation rec {
  name = "distrho-${rev}";

  src = fetchgit {
    url = "https://github.com/DISTRHO/DISTRHO-Ports.git";
    inherit rev;
    sha256 = "55dc52921bb757c3213da5ef6cab40909f39be3e3b41ba4c6cd66ad90bfb2e6c";
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

    # The old repo was removed and split into multiple repos. More
    # work is required to get everything to build and work.
    broken = true;
  };
}
