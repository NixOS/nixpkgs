{
  stdenv,
  lib,
  fetchFromGitHub,
  nix-update-script,
  cmake,
  ninja,
  pkg-config,
  writableTmpDirAsHomeHook,
  copyDesktopItems,
  makeDesktopItem,
  libx11,
  libxrandr,
  libxinerama,
  libxext,
  libxcursor,
  libxtst,
  freetype,
  fontconfig,
  webkitgtk_4_1,
  curl,
  alsa-lib,
  libsysprof-capture,
  pcre2,
  util-linux,
  libselinux,
  libsepol,
  libthai,
  libdatrie,
  libxdmcp,
  libdeflate,
  lerc,
  xz,
  libwebp,
  libxkbcommon,
  libepoxy,
  sqlite,

  buildStandalone ? true,
  buildVST3 ? true,
  buildLV2 ? true,
}:

let
  cmakeFormats = [
    (lib.optionalString buildStandalone "Standalone")
    (lib.optionalString buildVST3 "VST3")
    (lib.optionalString buildLV2 "LV2")
  ];
in

stdenv.mkDerivation {
  name = "socalabs-mverb";
  version = "0-unstable-2025-08-08";

  src =
    (fetchFromGitHub {
      owner = "FigBug";
      repo = "mverb";
      rev = "1f0a04029a16827ea809ece757ecc05f8f5ab682";
      fetchSubmodules = true;
      hash = "sha256-g0N9gQhdL8VMklJNjNmj9yHN18yjF0MURHvIBu/Uyss=";
    }).overrideAttrs
      (_: {
        GIT_CONFIG_COUNT = 1;
        GIT_CONFIG_KEY_0 = "url.https://github.com/.insteadOf";
        GIT_CONFIG_VALUE_0 = "git@github.com:";
      });

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "FORMATS Standalone VST VST3 AU LV2" "FORMATS ${lib.concatStringsSep " " cmakeFormats}"
  '';

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    writableTmpDirAsHomeHook
    copyDesktopItems
  ];

  buildInputs = [
    libx11
    libxrandr
    libxinerama
    libxext
    libxcursor
    libxtst
    freetype
    fontconfig
    webkitgtk_4_1
    curl
    alsa-lib
    libsysprof-capture
    pcre2
    util-linux
    libselinux
    libsepol
    libthai
    libdatrie
    libxdmcp
    libdeflate
    lerc
    xz
    libwebp
    libxkbcommon
    libepoxy
    sqlite
  ];

  cmakeFlags = [
    "--preset ninja-gcc"
    (lib.cmakeBool "JUCE_COPY_PLUGIN_AFTER_BUILD" false)
  ];

  # Fontconfig error: Cannot load default config file: No such file: (null)
  env.FONTCONFIG_FILE = "${fontconfig.out}/etc/fonts/fonts.conf";

  preBuild = "cd ../Builds/ninja-gcc";

  installPhase = ''
    runHook preInstall

    pushd Mverb2020_artefacts/Release
      ${lib.optionalString buildStandalone ''
        install -Dm755 Standalone/Mverb2020 -t $out/bin
      ''}

      ${lib.optionalString buildVST3 ''
        mkdir -p $out/lib/vst3
        cp -r VST3/Mverb2020.vst3 $out/lib/vst3
      ''}

      ${lib.optionalString buildLV2 ''
        mkdir -p $out/lib/lv2
        cp -r LV2/Mverb2020.lv2 $out/lib/lv2
      ''}
    popd

    runHook postInstall
  '';

  # JUCE dlopens these at runtime, standalone executable crashes without them
  NIX_LDFLAGS = [
    "-lX11"
    "-lXext"
    "-lXcomposite"
    "-lXcursor"
    "-lXinerama"
    "-lXrandr"
    "-lXrender"
    "-lXtst"
    "-lXdmcp"
  ];

  passthru.updateScript = nix-update-script { };

  desktopItems = [
    (makeDesktopItem {
      type = "Application";
      name = "socalabs-mverb";
      desktopName = "Socalabs MVerb";
      comment = "Socalabs Reverb Plugin (Standalone)";
      exec = "Mverb2020";
      categories = [
        "Audio"
        "AudioVideo"
      ];
    })
  ];

  meta = {
    description = "Reverb based on martineastwood's mverb";
    homepage = "https://socalabs.com/effects/mverb2020";
    platforms = [ "x86_64-linux" ];
    license = [ lib.licenses.bsd3 ];
    maintainers = [ lib.maintainers.mrtnvgr ];
    mainProgram = lib.optionalString buildStandalone "Mverb2020";
  };
}
