{
  stdenv,
  fetchFromGitHub,
  lib,
  cmake,
  pkg-config,
  alsa-lib,
  libX11,
  libXcomposite,
  libXcursor,
  libXinerama,
  libXrandr,
  libXtst,
  libXdmcp,
  libXext,
  xvfb,
  freetype,
  fontconfig,
  libGL,
  libjack2,
  curl,
  expat,
  vst2-sdk,
  nix-update-script,
  makeDesktopItem,
  copyDesktopItems,
  writableTmpDirAsHomeHook,
  # disable since its unfree
  enableVST2 ? false,
}:
let
  plugins = [
    "JE8086"
    "NodalRed2x"
    "Osirus"
    "OsirusFX"
    "OsTIrus"
    "OsTIrusFX"
    "Vavra"
    "VavraFX"
    "Xenia"
    "XeniaFX"
  ];
  desktopItems = map (
    pl:
    (makeDesktopItem {
      type = "Application";
      name = "${lib.toLower pl}";
      desktopName = "${pl} - DSP56300";
      comment = "Low Level Emulation of ${pl} (DSP56300)";
      categories = [
        "Audio"
        "AudioVideo"
      ];
    })
  ) plugins;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "gearmulator";
  version = "2.1.1";
  inherit desktopItems;

  src = fetchFromGitHub {
    owner = "dsp56300";
    repo = "gearmulator";
    tag = "${finalAttrs.version}";
    hash = "sha256-Q9cjYdf4sQ3ciF1yh3JpfEaGWVZjQPdBzbZjsOcSP1k=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    copyDesktopItems
    writableTmpDirAsHomeHook
  ];

  buildInputs = [
    alsa-lib
    libX11
    libXcomposite
    libXcursor
    libXinerama
    libXrandr
    libXtst
    libXdmcp
    libXext
    libXtst
    xvfb
    libGL
    libjack2
    freetype
    fontconfig
    curl
    expat
  ];

  postPatch = ''
    ${lib.optionalString enableVST2 ''
      ln -s ${vst2-sdk}/pluginterfaces source/vstsdk2.4.2/
      ln -s ${vst2-sdk}/public.sdk source/vstsdk2.4.2/
    ''}
  '';

  cmakeFlags = [
    (lib.cmakeBool "gearmulator_BUILD_JUCEPLUGIN" true)
    (lib.cmakeBool "gearmulator_BUILD_JUCEPLUGIN_VST2" enableVST2)
    (lib.cmakeBool "gearmulator_BUILD_JUCEPLUGIN_VST3" true)
    (lib.cmakeBool "gearmulator_BUILD_JUCEPLUGIN_Standalone" true)
    (lib.cmakeBool "gearmulator_BUILD_JUCEPLUGIN_CLAP" true)
    (lib.cmakeBool "gearmulator_BUILD_JUCEPLUGIN_LV2" true)
    (lib.cmakeBool "gearmulator_BUILD_FX_PLUGIN" true)
    (lib.cmakeBool "gearmulator_BUILD_JUCEPLUGIN_AU" false)
  ];

  strictDeps = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/vst3 $out/lib/clap $out/lib/lv2 $out/bin

    cp -r /build/source/bin/plugins/Release/CLAP/* $out/lib/clap
    cp -r /build/source/bin/plugins/Release/LV2/* $out/lib/lv2
    cp -r /build/source/bin/plugins/Release/Standalone/* $out/bin
    cp -r /build/source/bin/plugins/Release/VST3/* $out/lib/vst3
    ${lib.optionalString enableVST2 ''
      mkdir -p $out/lib/vst
      cp -r /build/source/bin/plugins/Release/VST/* $out/lib/vst
    ''}

     runHook postInstall
  '';

  NIX_LDFLAGS = (
    toString [
      "-lX11"
      "-lXext"
      "-lXcomposite"
      "-lXcursor"
      "-lXinerama"
      "-lXrandr"
      "-lXtst"
      "-lXdmcp"
    ]
  );

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Low Level Emulation of classic VA synths & effects of the late 90s/2000s by emulating the used ICs";
    homepage = "https://dsp56300.wordpress.com/";
    platforms = lib.platforms.linux;
    license = [ lib.licenses.gpl3 ] ++ lib.optional enableVST2 lib.licenses.unfree;
    maintainers = [ lib.maintainers.l1npengtul ];
  };
})
