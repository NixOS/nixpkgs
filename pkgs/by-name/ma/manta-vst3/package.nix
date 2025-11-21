{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  juce,
  alsa-lib,
  jack2,
  xorg,
  portaudio,
  freetype,
  fontconfig,
  libpng,
  zlib,
  bzip2,
  expat,
  brotli,
  libGL,
  mesa,
}:

stdenv.mkDerivation rec {
  pname = "manta";
  version = "unstable-2024-11-21";

  src = fetchFromGitHub {
    owner = "Mrugalla";
    repo = "Manta";
    rev = "57a76552853dc3d49341497cd61257f9ed6e81d0";
    sha256 = "0b61yjwxpf1c0df2v3zlyrhpkdhlqbr9apbj76gmcnxngf5nmj8r";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    juce
    alsa-lib
    jack2
    portaudio
    freetype
    fontconfig
    libpng
    zlib
    bzip2
    expat
    brotli

    # X11 libraries
    xorg.libX11
    xorg.libXext
    xorg.libXrandr
    xorg.libXinerama
    xorg.libXcursor
    xorg.libXcomposite

    # Graphics
    libGL
    mesa
  ];

  # We need to create the CMakeLists.txt since it won't exist in the original repo
  postPatch = ''
    # Create the CMakeLists.txt file
    cat > CMakeLists.txt << 'EOF'
cmake_minimum_required(VERSION 3.22)

project(Manta VERSION 1.0.0)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Find JUCE
find_package(JUCE CONFIG REQUIRED)

# Define plugin properties from Project.jucer
set(PLUGIN_NAME "Manta")
set(PLUGIN_MANUFACTURER "Mrugalla")
set(PLUGIN_MANUFACTURER_CODE "Mrug")
set(PLUGIN_CODE "8171")
set(PLUGIN_DESCRIPTION "Parallel Bandpass Filters And More")

# Add the plugin target
juce_add_plugin(''${PLUGIN_NAME}
    VERSION 1.0.0
    COMPANY_NAME "''${PLUGIN_MANUFACTURER}"
    COMPANY_WEBSITE "https://github.com/Mrugalla"
    COMPANY_EMAIL ""

    PLUGIN_MANUFACTURER_CODE ''${PLUGIN_MANUFACTURER_CODE}
    PLUGIN_CODE ''${PLUGIN_CODE}

    FORMATS VST3 LV2 Standalone
    PRODUCT_NAME "''${PLUGIN_NAME}"

    IS_SYNTH FALSE
    NEEDS_MIDI_INPUT TRUE
    NEEDS_MIDI_OUTPUT FALSE
    IS_MIDI_EFFECT FALSE

    EDITOR_WANTS_KEYBOARD_FOCUS FALSE

    COPY_PLUGIN_AFTER_BUILD FALSE

    VST3_CATEGORIES Fx
    LV2URI "https://github.com/Mrugalla/Manta"
)

# Source files
target_sources(''${PLUGIN_NAME} PRIVATE
    Source/Processor.cpp
    Source/Editor.cpp

    # arch
    Source/arch/Smooth.cpp
    Source/arch/State.cpp

    # audio
    Source/audio/AbsorbProcessor.cpp
    Source/audio/DryWetMix.cpp
    Source/audio/EnvelopeFollower.cpp
    Source/audio/Filter.cpp
    Source/audio/LatencyCompensation.cpp
    Source/audio/Meter.cpp
    Source/audio/MIDILearn.cpp
    Source/audio/MidSide.cpp
    Source/audio/Oversampling.cpp
    Source/audio/PitchGlitcher.cpp
    Source/audio/PRM.cpp
    Source/audio/WHead.cpp

    # gui
    Source/gui/Button.cpp
    Source/gui/ButtonParameterRandomizer.cpp
    Source/gui/Comp.cpp
    Source/gui/ContextMenu.cpp
    Source/gui/Events.cpp
    Source/gui/FilterResponseGraph.cpp
    Source/gui/GUIParams.cpp
    Source/gui/HighLevel.cpp
    Source/gui/Knob.cpp
    Source/gui/Label.cpp
    Source/gui/Layout.cpp
    Source/gui/MIDICCMonitor.cpp
    Source/gui/MIDIVoicesComp.cpp
    Source/gui/Menu.cpp
    Source/gui/Shader.cpp
    Source/gui/Shared.cpp
    Source/gui/TextEditor.cpp
    Source/gui/Tooltip.cpp
    Source/gui/Utils.cpp

    # param
    Source/param/Param.cpp
)

# Preprocessor definitions from Project.jucer
target_compile_definitions(''${PLUGIN_NAME} PRIVATE
    PPDEditorWidth=946
    PPDEditorHeight=574
    PPDHasEditor=true
    PPDHasPatchBrowser=true
    PPDHasSidechain=false
    PPDHasGainIn=true
    PPDHasUnityGain=true
    PPDHasHQ=false
    PPDHasStereoConfig=false
    PPDHasPolarity=true
    PPDHasLookahead=false
    PPDHasDelta=false
    PPDFPSKnobs=40
    PPDFPSMeters=40
    PPDFPSTextEditor=3
    PPDMetersUseRMS=true
    PPD_GainIn_Min=-12
    PPD_GainIn_Max=12
    PPD_GainOut_Min=-60
    PPD_GainOut_Max=60
    PPD_UnityGainDefault=true
    PPD_DebugFormularParser=false
    PPD_MixOrGainDry=1
    PPD_MIDINumVoices=0
    PPD_MaxXen=128
    PPDPitchShifterSizeMs=1000
    PPDPitchShifterNumVoices=7
)

# JUCE options
target_compile_definitions(''${PLUGIN_NAME} PRIVATE
    JUCE_STRICT_REFCOUNTEDPOINTER=1
    JUCE_VST3_CAN_REPLACE_VST2=0
    JUCE_ENABLE_REPAINT_DEBUGGING=0
    JUCE_WEB_BROWSER=0
    JUCE_USE_CURL=0
    JUCE_DISPLAY_SPLASH_SCREEN=1
)

# Binary resources
juce_add_binary_data(MantaData SOURCES
    Source/svg/logo.svg
    Source/svg/logo2.svg
    Source/fonts/Dosis/static/Dosis-Bold.ttf
    Source/fonts/Dosis/static/Dosis-ExtraBold.ttf
    Source/fonts/Dosis/static/Dosis-ExtraLight.ttf
    Source/fonts/Dosis/static/Dosis-Light.ttf
    Source/fonts/Dosis/static/Dosis-Medium.ttf
    Source/fonts/Dosis/static/Dosis-Regular.ttf
    Source/fonts/Dosis/static/Dosis-SemiBold.ttf
    Source/fonts/Dosis/Dosis-VariableFont_wght.ttf
    Source/fonts/Lobster/Lobster-Regular.ttf
    Source/fonts/Ms_Madi/MsMadi-Regular.ttf
    Source/fonts/nel19.ttf
    Source/cursor.png
    Source/cursorCross.png
    Source/gui/menu.xml
    Source/vst3_logo_small.png
    Source/outtakes.txt
)

# Link JUCE modules
target_link_libraries(''${PLUGIN_NAME} PRIVATE
    MantaData
    juce::juce_audio_basics
    juce::juce_audio_devices
    juce::juce_audio_formats
    juce::juce_audio_plugin_client
    juce::juce_audio_processors
    juce::juce_audio_utils
    juce::juce_core
    juce::juce_data_structures
    juce::juce_dsp
    juce::juce_events
    juce::juce_graphics
    juce::juce_gui_basics
    juce::juce_gui_extra
)

# Set include directories
target_include_directories(''${PLUGIN_NAME} PRIVATE
    Source
)
EOF
  '';

  # Set up environment for CMake configuration
  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
  ];

  # Ensure proper linking
  env = {
    PKG_CONFIG_PATH = lib.makeSearchPath "lib/pkgconfig" [
      alsa-lib
      jack2
      freetype
      fontconfig
      libpng
      zlib
      bzip2
      expat
    ];
  };

  # Custom install phase to handle JUCE plugin formats properly
  installPhase = ''
    runHook preInstall

    # Create output directories
    mkdir -p $out/bin
    mkdir -p $out/lib/vst3
    mkdir -p $out/lib/lv2
    mkdir -p $out/share/applications
    mkdir -p $out/share/pixmaps

    # Install standalone application
    if [ -f "Manta_artefacts/Release/Standalone/Manta" ]; then
      cp "Manta_artefacts/Release/Standalone/Manta" $out/bin/manta
      chmod +x $out/bin/manta
    fi

    # Install VST3 plugin
    if [ -d "Manta_artefacts/Release/VST3/Manta.vst3" ]; then
      cp -r "Manta_artefacts/Release/VST3/Manta.vst3" $out/lib/vst3/
    fi

    # Install LV2 plugin
    if [ -d "Manta_artefacts/Release/LV2/Manta.lv2" ]; then
      cp -r "Manta_artefacts/Release/LV2/Manta.lv2" $out/lib/lv2/
    fi

    # Create desktop file for the standalone application
    cat > $out/share/applications/manta.desktop << EOF
[Desktop Entry]
Type=Application
Name=Manta
Comment=Parallel Bandpass Filters And More
Exec=$out/bin/manta
Icon=manta
Categories=Audio;AudioVideo;
Terminal=false
EOF

    # Create a simple icon placeholder
    echo "Manta VST" > $out/share/pixmaps/manta.txt

    runHook postInstall
  '';

  # Ensure runtime dependencies are available
  postFixup = ''
    # Fix up the standalone binary
    if [ -f "$out/bin/manta" ]; then
      patchelf --set-rpath "${lib.makeLibraryPath buildInputs}:$(patchelf --print-rpath $out/bin/manta)" $out/bin/manta || true
    fi

    # Fix up VST3 plugin
    if [ -f "$out/lib/vst3/Manta.vst3/Contents/x86_64-linux/Manta.so" ]; then
      patchelf --set-rpath "${lib.makeLibraryPath buildInputs}:$(patchelf --print-rpath $out/lib/vst3/Manta.vst3/Contents/x86_64-linux/Manta.so)" $out/lib/vst3/Manta.vst3/Contents/x86_64-linux/Manta.so || true
    fi

    # Fix up LV2 plugin
    if [ -f "$out/lib/lv2/Manta.lv2/libManta.so" ]; then
      patchelf --set-rpath "${lib.makeLibraryPath buildInputs}:$(patchelf --print-rpath $out/lib/lv2/Manta.lv2/libManta.so)" $out/lib/lv2/Manta.lv2/libManta.so || true
    fi
  '';

  meta = with lib; {
    description = "Parallel bandpass filters and resonator VST plugin";
    longDescription = ''
      Manta is a JUCE-based audio plugin inspired by Dan Worrall's technique
      of using parallel bandpass filters to fatten up drums. Features include
      streamlined workflow, comb filters, ring modulation, formula parser for
      waveform generation, and tuning editor for xenharmonic scales.
    '';
    homepage = "https://github.com/Mrugalla/Manta";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ S3r4f1n ];
    platforms = platforms.linux;
    mainProgram = "manta";
  };
}
