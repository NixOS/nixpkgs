{
  stdenv,
  lib,
  fetchurl,
  fetchFromGitHub,
  runCommand,
  gitUpdater,
  catch2_3,
  cmake,
  fontconfig,
  pkg-config,
  libX11,
  libXrandr,
  libXinerama,
  libXext,
  libXcursor,
  freetype,
  alsa-lib,

  # Only able to test this myself in Linux
  withStandalone ? stdenv.hostPlatform.isLinux,
}:

let
  # Required version, base URL and expected location specified in cmake/CPM.cmake
  cpmDownloadVersion = "0.40.2";
  cpmSrc = fetchurl {
    url = "https://github.com/cpm-cmake/CPM.cmake/releases/download/v${cpmDownloadVersion}/CPM.cmake";
    hash = "sha256-yM3DLAOBZTjOInge1ylk3IZLKjSjENO3EEgSpcotg10=";
  };
  cpmSourceCache = runCommand "cpm-source-cache" { } ''
    mkdir -p $out/cpm
    ln -s ${cpmSrc} $out/cpm/CPM_${cpmDownloadVersion}.cmake
  '';

  pathMappings = [
    {
      from = "LV2";
      to = "${placeholder "out"}/${
        if stdenv.hostPlatform.isDarwin then "Library/Audio/Plug-Ins/LV2" else "lib/lv2"
      }";
    }
    {
      from = "VST3";
      to = "${placeholder "out"}/${
        if stdenv.hostPlatform.isDarwin then "Library/Audio/Plug-Ins/VST3" else "lib/vst3"
      }";
    }
    # this one's a guess, don't know where ppl have agreed to put them yet
    {
      from = "CLAP";
      to = "${placeholder "out"}/${
        if stdenv.hostPlatform.isDarwin then "Library/Audio/Plug-Ins/CLAP" else "lib/clap"
      }";
    }
  ]
  ++ lib.optionals withStandalone [
    {
      from = "Standalone";
      to = "${placeholder "out"}/bin";
    }
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Audio Unit is a macOS-specific thing
    {
      from = "AU";
      to = "${placeholder "out"}/Library/Audio/Plug-Ins/Components";
    }
  ];

  x11Libs = [
    libX11
    libXrandr
    libXinerama
    libXext
    libXcursor
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "fire";
  # 1.5.0b is considered a beta release of 1.5.0, but gitUpdater identifies 1.5.0b as the newer version
  # Sanity checked manually. Drop this once running the updateScript doesn't produce a downgrade.
  # nixpkgs-update: no auto update
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "jerryuhoo";
    repo = "Fire";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-i8viPGErCuLSuRWstDtLwQ3XBz9gfiHin7Zvvq8l3kA=";
  };

  postPatch =
    let
      formatsListing = lib.strings.concatMapStringsSep " " (entry: entry.from) pathMappings;
    in
    ''
      # Allow all the formats we can handle
      # Set LV2URI again for LV2 build
      # Disable automatic copying of built plugins during buildPhase, it defaults
      # into user home and we want to have building & installing separated.
      substituteInPlace CMakeLists.txt \
        --replace-fail 'set(FORMATS' 'set(FORMATS ${formatsListing}) #' \
        --replace-fail 'BUNDLE_ID "''${BUNDLE_ID}"' 'BUNDLE_ID "''${BUNDLE_ID}" LV2URI "https://www.bluewingsmusic.com/Fire/"' \
        --replace-fail 'COPY_PLUGIN_AFTER_BUILD TRUE' 'COPY_PLUGIN_AFTER_BUILD FALSE'

      # Regression tests require big sound files stored in LFS, skip them
      rm -v tests/RegressionTests.cpp
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      # Remove hardcoded LTO flags: needs extra setup on Linux
      substituteInPlace CMakeLists.txt \
        --replace-fail 'juce::juce_recommended_lto_flags' '# Not forcing LTO'
    ''
    + lib.optionalString (!finalAttrs.finalPackage.doCheck) ''
      substituteInPlace CMakeLists.txt \
        --replace-fail 'include(Tests)' '# Not building tests' \
        --replace-fail 'include(Benchmarks)' '# Not building benchmark test'
    '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    catch2_3
    fontconfig
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux (
    x11Libs
    ++ [
      freetype
      alsa-lib
    ]
  );

  cmakeFlags = [
    (lib.cmakeFeature "CPM_SOURCE_CACHE" "${cpmSourceCache}")
    (lib.cmakeBool "CPM_LOCAL_PACKAGES_ONLY" true)
    (lib.cmakeFeature "Catch2_SOURCE_DIR" "${catch2_3.src}")
  ];

  installPhase = ''
    runHook preInstall

  ''
  + lib.strings.concatMapStringsSep "\n" (entry: ''
    mkdir -p ${entry.to}
    # Exact path of the build artefact depends on used CMAKE_BUILD_TYPE
    cp -r -t ${entry.to} Fire_artefacts/${finalAttrs.cmakeBuildType or "Release"}/${entry.from}/*
  '') pathMappings
  + ''

    runHook postInstall
  '';

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  # Standalone dlopen's X11 libraries
  postFixup = lib.strings.optionalString (withStandalone && stdenv.hostPlatform.isLinux) ''
    patchelf --add-rpath ${lib.makeLibraryPath x11Libs} $out/bin/Fire
  '';

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "Multi-band distortion plugin by Wings";
    homepage = "https://www.bluewingsmusic.com/Fire";
    license = lib.licenses.agpl3Only; # Not clarified if Only or Plus
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ OPNA2608 ];
  }
  // lib.optionalAttrs withStandalone {
    mainProgram = "Fire";
  };
})
