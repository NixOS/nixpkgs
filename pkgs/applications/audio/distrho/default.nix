{ stdenv, fetchgit, alsaLib, fftwSinglePrec, freetype, jack2
, libxslt, lv2, pkgconfig, premake3, xlibs }:

stdenv.mkDerivation rec {
  name = "distrho-ports-git-2015-01-28";

  src = fetchgit {
    url = "https://github.com/DISTRHO/DISTRHO-Ports.git";
    rev = "b4e2dc24802fe6804c60fcd2559a0bca46b7709c";
    sha256 = "661ff6f7cda71a8dd08cbcea3f560e99f0fc2232053cbc9a2aaba854137805c6";
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
