{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  python3,
  writableTmpDirAsHomeHook,
  copyDesktopItems,
  makeDesktopItem,
  nix-update-script,
  alsa-lib,
  curl,
  fontconfig,
  freetype,
  libGL,
  libjack2,
  libx11,
  libxcursor,
  libxext,
  libxi,
  libxinerama,
  libxrandr,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "resonarium";
  version = "0.0.11";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "gabrielsoule";
    repo = "resonarium";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-/ezkq1er/OteoLrqXe60/QmC5BOqoRcoGvtr93wBioE=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    # find_package(Python3 COMPONENTS Interpreter Development REQUIRED) is
    # called unconditionally at the top of CMakeLists.txt, so Python is needed
    # at configure time even though we don't build the python bindings.
    python3
    # JUCE's COPY_PLUGIN_AFTER_BUILD writes into $HOME/.{vst3,lv2}; also
    # fontconfig wants a writable cache dir at build time.
    writableTmpDirAsHomeHook
    copyDesktopItems
  ];

  buildInputs = [
    alsa-lib
    curl
    fontconfig
    freetype
    libGL
    libjack2
    libx11
    libxcursor
    libxext
    libxi
    libxinerama
    libxrandr
  ];

  postPatch = ''
    # Upstream forgot to bump the in-source version for v0.0.11; sync it
    # to the git tag so the About screen and plugin metadata agree.
    substituteInPlace CMakeLists.txt \
    --replace-fail "set(PLUGIN_VERSION 0.0.10)" \
                    "set(PLUGIN_VERSION ${finalAttrs.version})"
    substituteInPlace plugin/Source/PluginProcessor.cpp \
    --replace-fail '"0.0.10 (INST) ALPHA"' '"${finalAttrs.version} (INST) ALPHA"' \
    --replace-fail '"0.0.10 (FX) ALPHA"'   '"${finalAttrs.version} (FX) ALPHA"'

    # melatonin_perfetto's CMakeLists fetches CPM.cmake and the Perfetto SDK
    # from the network at configure time, which the Nix sandbox blocks. The
    # PERFETTO compile-time switch is OFF here, so melatonin_perfetto.h
    # compiles every tracing macro to a no-op and never includes <perfetto.h>.
    # Replace the module's CMakeLists with a stub that just registers the
    # JUCE module and exposes the expected target/alias names.
    cat > modules/melatonin_perfetto/CMakeLists.txt <<'EOF'
    juce_add_module("''${CMAKE_CURRENT_LIST_DIR}/melatonin_perfetto")
    add_library(perfetto INTERFACE)
    add_library(perfetto::perfetto ALIAS perfetto)
    target_link_libraries(melatonin_perfetto INTERFACE perfetto::perfetto)
    add_library(Melatonin::Perfetto ALIAS melatonin_perfetto)
    EOF
  '';

  enableParallelBuilding = true;

  env = {
    # JUCE dlopen's these at runtime; standalone executable crashes without them.
    NIX_LDFLAGS = toString [
      "-lX11"
      "-lXext"
      "-lXcursor"
      "-lXinerama"
      "-lXrandr"
      "-ljack"
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

  # Build only the plugin/standalone targets; skip Resonarium_Python so we
  # don't have to install a python module as part of an audio-plugin package.
  ninjaFlags = [
    "Resonarium_Instrument_All"
    "Resonarium_Effect_All"
  ];

  # The upstream `install` rules target "Applications" / "Program Files",
  # which makes no sense on Linux and trips CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION.
  dontUseCmakeInstall = true;

  installPhase = ''
    runHook preInstall

    instArt="Resonarium_Instrument_artefacts/Release"
    fxArt="Resonarium_Effect_artefacts/Release"

    # VST3 bundles
    install -dm755 "$out/lib/vst3"
    cp -r "$instArt/VST3/Resonarium.vst3"           "$out/lib/vst3/"
    cp -r "$fxArt/VST3/Resonarium Effect.vst3"      "$out/lib/vst3/"

    # LV2 bundles
    install -dm755 "$out/lib/lv2"
    cp -r "$instArt/LV2/Resonarium.lv2"             "$out/lib/lv2/"
    cp -r "$fxArt/LV2/Resonarium Effect.lv2"        "$out/lib/lv2/"

    # Standalone executables (drop the space in the Effect binary name)
    install -Dm755 "$instArt/Standalone/Resonarium"        "$out/bin/Resonarium"
    install -Dm755 "$fxArt/Standalone/Resonarium Effect"   "$out/bin/Resonarium-Effect"

    # Icon for the .desktop entries
    install -Dm644 "$src/plugin/Resources/resonarium_logo.png" \
      "$out/share/icons/hicolor/512x512/apps/resonarium.png"

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "resonarium";
      desktopName = "Resonarium";
      genericName = "Physical Modelling Synthesizer";
      comment = "MPE-compatible physical modelling synthesizer based on coupled string waveguides";
      exec = "Resonarium";
      icon = "resonarium";
      categories = [
        "AudioVideo"
        "Audio"
        "Music"
      ];
      keywords = [
        "synth"
        "synthesizer"
        "audio"
        "MPE"
        "waveguide"
      ];
    })
    (makeDesktopItem {
      name = "resonarium-effect";
      desktopName = "Resonarium Effect";
      genericName = "Physical Modelling Audio Effect";
      comment = "Resonarium as an audio effect, applying its physical models to external input";
      exec = "Resonarium-Effect";
      icon = "resonarium";
      categories = [
        "AudioVideo"
        "Audio"
      ];
      keywords = [
        "audio"
        "effect"
        "resonator"
        "waveguide"
      ];
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "MPE-compatible physical modelling synthesizer based on coupled string waveguides";
    longDescription = ''
      Resonarium is a physical-modelling synthesizer plugin and standalone
      application designed for abstract sound design, exploration and
      open-ended play. Its voice is a network of coupled waveguide
      resonators driven by configurable exciters, and it is intended to be
      played with MPE-capable controllers such as the Ableton Push 3, the
      Expressive E Osmose or the ROLI Seaboard.

      This package builds the Instrument (synth) and Effect variants and
      installs VST3 and LV2 bundles as well as the standalone applications.
    '';
    homepage = "https://github.com/gabrielsoule/resonarium";
    changelog = "https://github.com/gabrielsoule/resonarium/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    mainProgram = "Resonarium";
    maintainers = with lib.maintainers; [ magnetophon ];
    platforms = lib.platforms.linux;
  };
})
