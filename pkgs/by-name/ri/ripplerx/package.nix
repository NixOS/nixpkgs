{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  writableTmpDirAsHomeHook,
  alsa-lib,
  expat,
  fontconfig,
  freetype,
  libx11,
  libxcursor,
  libxext,
  libxinerama,
  libxrandr,
  nix-update-script,
  makeDesktopItem,
  copyDesktopItems,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ripplerx";
  version = "1.5.18";

  src = fetchFromGitHub {
    owner = "tiagolr";
    repo = "ripplerx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lHLAJ8eCmn/WFYxGl/zIq8a2xPKqzpB7tilffJcXhM4=";
    fetchSubmodules = true;
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    writableTmpDirAsHomeHook # fontconfig cache + $HOME/.{lv2,vst3}
    copyDesktopItems
  ];

  buildInputs = [
    alsa-lib
    expat
    fontconfig
    freetype
    libx11
    libxcursor
    libxext
    libxinerama
    libxrandr
  ];

  env = {
    # JUCE dlopens these at runtime, standalone executable crashes without them
    NIX_LDFLAGS = toString [
      "-lX11"
      "-lXext"
      "-lXcursor"
      "-lXinerama"
      "-lXrandr"
    ];

    NIX_CFLAGS_COMPILE = toString [
      # juce, compiled in this build as part of a Git submodule, uses `-flto` as
      # a Link Time Optimization flag, and instructs the plugin compiled here to
      # use this flag to. This breaks the build for us. Using _fat_ LTO allows
      # successful linking while still providing LTO benefits. If our build of
      # `juce` was used as a dependency, we could have patched that `-flto` line
      # in our juce's source, but that is not possible because it is used as a
      # Git Submodule.
      "-ffat-lto-objects"
    ];

    # Fontconfig error: Cannot load default config file: No such file: (null)
    FONTCONFIG_FILE = "${fontconfig.out}/etc/fonts/fonts.conf";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib/{lv2,vst3}

    pushd RipplerX_artefacts/Release
    cp -r "Standalone/RipplerX" $out/bin/ripplerx
    cp -r "LV2/RipplerX.lv2" $out/lib/lv2
    cp -r "VST3/RipplerX.vst3" $out/lib/vst3
    popd

    install -Dm644 ../doc/logo.svg \
      $out/share/icons/hicolor/scalable/apps/ripplerx.svg

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      desktopName = "RipplerX";
      comment = "Physically modeled synth";
      name = "ripplerx";
      exec = "ripplerx";
      icon = "ripplerx";
      terminal = false;
      categories = [
        "Audio"
        "AudioVideo"
        "Midi"
        "Music"
      ];
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Physically modeled synth";
    longDescription = ''
      RipplerX is a physically modeled synth, capable of sounds similar to AAS Chromaphone and Ableton Collision.
    '';
    homepage = "https://github.com/tiagolr/ripplerx";
    mainProgram = "ripplerx";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ eljamm ];
    platforms = lib.platforms.linux;
  };
})
