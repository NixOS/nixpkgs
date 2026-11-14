{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  writableTmpDirAsHomeHook,
  juce,
  libx11,
  libxrandr,
  libxinerama,
  libxext,
  libxcursor,
  libxtst,
  fontconfig,
  alsa-lib,
  libxdmcp,
  freetype,
  nix-update-script,

  buildVST3 ? true,
  buildStandalone ? true,
  buildLV2 ? true,
  buildCLAP ? true,
}:
let
  clap-juce-extensions = fetchFromGitHub {
    owner = "free-audio";
    repo = "clap-juce-extensions";
    rev = "645ed2fd0949d36639e3d63333f26136df6df769";
    hash = "sha256-Lx88nyEFjPLA5yh8rrqBdyZIxe/j0FgIHoyKcbjuuI4=";
    fetchSubmodules = true;
  };

  chowdsp_utils = fetchFromGitHub {
    owner = "Chowdhury-DSP";
    repo = "chowdsp_utils";
    rev = "e97b826ef3de0b0fd92b15cb2e286076f678d8b9";
    hash = "sha256-YB6VL1kDCmnW9hmDeeBrqQAdr7P8F5vMXOzOU9RoFtA=";
  };

  formats = lib.concatStringsSep " " [
    (lib.optionalString buildVST3 "VST3")
    (lib.optionalString buildStandalone "Standalone")
    (lib.optionalString buildLV2 "LV2")
  ];
in
stdenv.mkDerivation {
  pname = "hamburger";
  version = "0-unstable-2026-03-21";

  src = fetchFromGitHub {
    owner = "Davit-G";
    repo = "Hamburger";
    rev = "e5ecc06e5bb33161d4233f0d621416c440c1bc73";
    hash = "sha256-D/gmwMFTHcRm5kCxc3Q+CmsdpLcr4vxFZA9rrLxLCz0=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "FORMATS VST3 Standalone AU LV2" "FORMATS ${formats}"  \
      --replace-fail "juce::juce_recommended_lto_flags" "# Not forcing LTO" \
      --replace-fail "COPY_PLUGIN_AFTER_BUILD TRUE" "COPY_PLUGIN_AFTER_BUILD FALSE"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    writableTmpDirAsHomeHook
  ];

  buildInputs = [
    alsa-lib
    libx11
    libxcursor
    libxdmcp
    libxext
    libxinerama
    libxrandr
    libxtst
    freetype
    fontconfig
  ];

  cmakeFlags = [
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_JUCE" "${juce.src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_CLAP-JUCE-EXTENSIONS" "${clap-juce-extensions}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_CHOWDSP_UTILS" "${chowdsp_utils}")
    (lib.cmakeBool "BUILD_CLAP" buildCLAP)
  ];

  # Fontconfig error: Cannot load default config file: No such file: (null)
  env.FONTCONFIG_FILE = "${fontconfig.out}/etc/fonts/fonts.conf";

  installPhase = ''
    runHook preInstall

    pushd Hamburger_artefacts/Release
      ${lib.optionalString buildStandalone ''
        install -Dm755 Standalone/Hamburger -t $out/bin
      ''}

      ${lib.optionalString buildVST3 ''
        mkdir -p $out/lib/vst3
        cp -r VST3/Hamburger.vst3 $out/lib/vst3
      ''}

      ${lib.optionalString buildLV2 ''
        mkdir -p $out/lib/lv2
        cp -r LV2/Hamburger.lv2 $out/lib/lv2
      ''}

      ${lib.optionalString buildCLAP ''
        mkdir -p $out/lib/clap
        cp -r CLAP/Hamburger.clap $out/lib/clap
      ''}
    popd

    runHook postInstall
  '';

  # Needed by standalone
  NIX_LDFLAGS = [
    "-lX11"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Distortion plugin with inbuilt dynamics controls and equalisation";
    homepage = "https://aviaryaudio.com/plugins/hamburgerv2";
    platforms = lib.platforms.linux;
    license = with lib.licenses; [
      agpl3Plus
      ncsa
    ];
    maintainers = [ lib.maintainers.mrtnvgr ];
  }
  // lib.optionalAttrs buildStandalone {
    mainProgram = "Hamburger";
  };
}
