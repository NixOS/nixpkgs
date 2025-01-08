{
  lib,
  stdenv,
  alsa-lib,
  fetchFromGitHub,
  fftwFloat,
  freetype,
  libGL,
  libX11,
  libXcursor,
  libXext,
  libXrender,
  meson,
  ninja,
  pkg-config,
}:

let
  rpathLibs = [
    fftwFloat
  ];
in
stdenv.mkDerivation {
  pname = "distrho-ports";
  version = "2021-03-15-unstable-2024-05-01";

  src = fetchFromGitHub {
    owner = "DISTRHO";
    repo = "DISTRHO-Ports";
    rev = "b3596e6a690eb0556e69e8b6d943fee2dfbb04fb";
    sha256 = "00fgqwayd20akww3n2imyqscmyrjyc9jj0ar13k9dhpaxqk2jxbf";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
  ];

  buildInputs = rpathLibs ++ [
    alsa-lib
    freetype
    libGL
    libX11
    libXcursor
    libXext
    libXrender
  ];

  env.NIX_CFLAGS_COMPILE = toString [ "-fpermissive" ];

  postFixup = ''
    for file in \
      $out/lib/lv2/vitalium.lv2/vitalium.so \
      $out/lib/vst/vitalium.so \
      $out/lib/vst3/vitalium.vst3/Contents/x86_64-linux/vitalium.so
    do
      patchelf --set-rpath "${lib.makeLibraryPath rpathLibs}:$(patchelf --print-rpath $file)" $file
    done
  '';

  meta = {
    homepage = "http://distrho.sourceforge.net/ports";
    description = "Linux audio plugins and LV2 ports";
    longDescription = ''
      Includes:
      - arctican-function
      - arctican-pilgrim
      - dexed
      - drowaudio-distortion
      - drowaudio-distortionshaper
      - drowaudio-flanger
      - drowaudio-reverb
      - drowaudio-tremolo
      - drumsynth
      - easySSP
      - eqinox
      - HiReSam
      - juce-opl
      - klangfalter
      - LUFSMeter
      - LUFSMeter-Multi
      - luftikus
      - obxd
      - pitchedDelay
      - refine
      - stereosourceseparation
      - swankyamp
      - tal-dub-3
      - tal-filter
      - tal-filter-2
      - tal-noisemaker
      - tal-reverb
      - tal-reverb-2
      - tal-reverb-3
      - tal-vocoder-2
      - temper
      - vex
      - vitalium
      - wolpertinger
    '';
    license = with lib.licenses; [
      gpl2Only
      gpl3Only
      gpl2Plus
      lgpl2Plus
      lgpl3Only
      mit
    ];
    maintainers = [ ];
    platforms = lib.systems.inspect.patternLogicalAnd lib.systems.inspect.patterns.isLinux lib.systems.inspect.patterns.isx86;
  };
}
