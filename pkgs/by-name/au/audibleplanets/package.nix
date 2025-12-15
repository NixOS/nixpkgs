{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  writableTmpDirAsHomeHook,
  libx11,
  libxcursor,
  libxrandr,
  libxinerama,
  libxext,
  freetype,
  fontconfig,
  expat,
  alsa-lib,
  nix-update-script,

  buildStandalone ? true,
  buildVST3 ? true,
  buildLV2 ? true,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "audibleplanets";
  version = "1.2.3a";

  src = fetchFromGitHub {
    owner = "gregrecco67";
    repo = "AudiblePlanets";

    # TODO: change to finalAttrs.version when tag will be synced with the release
    tag = "v1.2.3";

    hash = "sha256-JJx0sWI4HJZ0B9FQsx1EHVCS8QnmaNTGNxEKEyXlqjU=";
    fetchSubmodules = true;
  };

  patches = [
    ./armfix.diff
  ];

  postPatch =
    let
      formats = lib.concatStringsSep " " [
        (lib.optionalString buildStandalone "Standalone")
        (lib.optionalString buildVST3 "VST3")
        (lib.optionalString buildLV2 "LV2")
      ];
    in
    ''
      substituteInPlace CMakeLists.txt \
        --replace-fail "juce::juce_recommended_lto_flags" "# Not enforcing lto" \
        --replace-fail "COPY_PLUGIN_AFTER_BUILD TRUE" "COPY_PLUGIN_AFTER_BUILD FALSE" \
        --replace-fail "set(FORMATS Standalone AU VST3 LV2)" "set(FORMATS ${formats})"
    '';

  nativeBuildInputs = [
    cmake
    pkg-config
    writableTmpDirAsHomeHook
  ];

  buildInputs = [
    libx11
    libxcursor
    libxrandr
    libxinerama
    libxext
    freetype
    fontconfig
    expat
    alsa-lib
  ];

  # Fontconfig error: Cannot load default config file: No such file: (null)
  env.FONTCONFIG_FILE = "${fontconfig.out}/etc/fonts/fonts.conf";

  # Needed for standalone
  NIX_LDFLAGS = [
    "-lX11"
  ];

  installPhase = ''
    runHook preInstall

    pushd AudiblePlanets_artefacts/Release
      ${lib.optionalString buildStandalone ''
        mkdir -p $out/bin
        cp -r "Standalone/Audible Planets" $out/bin/audibleplanets
      ''}

      ${lib.optionalString buildVST3 ''
        mkdir -p $out/lib/vst3
        cp -r "VST3/Audible Planets.vst3" $out/lib/vst3
      ''}

      ${lib.optionalString buildLV2 ''
        mkdir -p $out/lib/lv2
        cp -r "LV2/Audible Planets.lv2" $out/lib/lv2
      ''}
    popd

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "An expressive, quasi-Ptolemaic semi-modular synthesizer";
    homepage = "https://github.com/gregrecco67/AudiblePlanets";
    platforms = lib.platforms.linux;
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = [ lib.maintainers.mrtnvgr ];
  }
  // lib.optionalAttrs buildStandalone {
    mainProgram = "audibleplanets";
  };
})
