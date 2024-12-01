{
  stdenv,
  lib,
  fetchFromGitHub,
  unstableGitUpdater,
  catch2_3,
  cmake,
  pkg-config,
  libX11,
  libXrandr,
  libXinerama,
  libXext,
  libXcursor,
  freetype,
  alsa-lib,
  apple-sdk_11,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fire";
  version = "1.0.1-unstable-2024-10-22";

  src = fetchFromGitHub {
    owner = "jerryuhoo";
    repo = "Fire";
    rev = "4c3275caa0dbd9e65c6c3d574cc5ac1c828e529a";
    fetchSubmodules = true;
    hash = "sha256-DyYP/uDawa+m2FtNvEvu36iRl6zfMyGNMMad5f/rX4k=";
  };

  postPatch =
    ''
      # Disable automatic copying of built plugins during buildPhase, it defaults
      # into user home and we want to have building & installing separated.
      substituteInPlace CMakeLists.txt \
        --replace-fail 'COPY_PLUGIN_AFTER_BUILD TRUE' 'COPY_PLUGIN_AFTER_BUILD FALSE'
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

  buildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
      libX11
      libXrandr
      libXinerama
      libXext
      libXcursor
      freetype
      alsa-lib
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ apple-sdk_11 ];

  cmakeFlags = [
    (lib.cmakeBool "FETCHCONTENT_FULLY_DISCONNECTED" true)
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_CATCH2" "${catch2_3.src}")
  ];

  installPhase =
    let
      pathMappings =
        [
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
        ++ lib.optionals stdenv.hostPlatform.isDarwin [
          {
            from = "AU";
            to = "${placeholder "out"}/Library/Audio/Plug-Ins/Components";
          }
        ];
    in
    ''
      runHook preInstall

    ''
    + lib.strings.concatMapStringsSep "\n" (entry: ''
      mkdir -p ${entry.to}
      # Exact path of the build artefact depends on used CMAKE_BUILD_TYPE
      cp -r Fire_artefacts/*/${entry.from}/* ${entry.to}/
    '') pathMappings
    + ''

      runHook postInstall
    '';

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };

  meta = {
    description = "Multi-band distortion plugin by Wings";
    homepage = "https://github.com/jerryuhoo/Fire";
    license = lib.licenses.agpl3Only; # Not clarified if Only or Plus
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ OPNA2608 ];
  };
})
