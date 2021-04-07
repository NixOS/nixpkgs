{ lib, stdenv
, alsaLib
, fetchFromGitHub
, freetype
, libGL
, libX11
, libXcursor
, libXext
, libXrender
, meson
, ninja
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "distrho-ports";
  version = "2020-07-14";

  src = fetchFromGitHub {
    owner = "DISTRHO";
    repo = "DISTRHO-Ports";
    rev = version;
    sha256 = "03ji41i6dpknws1vjwfxnl8c8bgisv2ng8xa4vqy2473k7wgdw4v";
  };

  nativeBuildInputs = [ pkg-config meson ninja ];

  buildInputs = [
    alsaLib
    freetype
    libGL
    libX11
    libXcursor
    libXext
    libXrender
  ];

  meta = with lib; {
    homepage = "http://distrho.sourceforge.net/ports";
    description = "Linux audio plugins and LV2 ports";
    longDescription = ''
      Includes:
        arctican-function
        arctican-pilgrim
        dexed
        drowaudio-distortion
        drowaudio-distortionshaper
        drowaudio-flanger
        drowaudio-reverb
        drowaudio-tremolo
        drumsynth
        easySSP
        eqinox
        HiReSam
        juce-opl
        klangfalter
        LUFSMeter
        LUFSMeter-Multi
        luftikus
        obxd
        pitchedDelay
        refine
        stereosourceseparation
        tal-dub-3
        tal-filter
        tal-filter-2
        tal-noisemaker
        tal-reverb
        tal-reverb-2
        tal-reverb-3
        tal-vocoder-2
        temper
        vex
        wolpertinger
    '';
    license = with licenses; [ gpl2 gpl3 gpl2Plus lgpl3 mit ];
    maintainers = [ maintainers.goibhniu ];
    platforms = [ "x86_64-linux" ];
  };
}
