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
  name = "socalabs-loser-ports";
  version = "0-unstable-2025-09-01";

  src =
    (fetchFromGitHub {
      owner = "FigBug";
      repo = "LoserPorts";
      rev = "eeeff7eedd6456224a92ba8fad968abbcec628f3";
      fetchSubmodules = true;
      hash = "sha256-u1Q2Vx/aebvtRryqegYFr8eqTigjpRvc7Wc6jD+fLUU=";
    }).overrideAttrs
      (_: {
        GIT_CONFIG_COUNT = 1;
        GIT_CONFIG_KEY_0 = "url.https://github.com/.insteadOf";
        GIT_CONFIG_VALUE_0 = "git@github.com:";
      });

  patches = [ ./use-plugin-formats.diff ];

  postPatch = ''
    substituteInPlace plugins/*/CMakeLists.txt \
      --replace-fail "juce::juce_recommended_lto_flags" "# no lto"
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
    (lib.cmakeFeature "PLUGIN_FORMATS" (lib.concatStringsSep ";" cmakeFormats))
  ];

  # Fontconfig error: Cannot load default config file: No such file: (null)
  env.FONTCONFIG_FILE = "${fontconfig.out}/etc/fonts/fonts.conf";

  preBuild = "cd ../Builds/ninja-gcc";

  installPhase =
    let
      plugins = [
        "SimpleVerb"
        "StereoEnhancer"
        "StereoProcessor"
      ];

      mkPlugin = plugin: ''
        pushd ${plugin}/${plugin}_artefacts/Release
          ${lib.optionalString buildStandalone ''
            install -Dm755 Standalone/${plugin} -t $out/bin
          ''}

          ${lib.optionalString buildVST3 ''
            mkdir -p $out/lib/vst3
            cp -r VST3/${plugin}.vst3 $out/lib/vst3
          ''}

          ${lib.optionalString buildLV2 ''
            mkdir -p $out/lib/lv2
            cp -r LV2/${plugin}.lv2 $out/lib/lv2
          ''}
        popd
      '';
    in
    ''
      runHook preInstall

      pushd plugins
        ${lib.concatStringsSep "\n" (map mkPlugin plugins)}
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

  meta = {
    description = "Various plugins by Michael Gruhn ported to JUCE";
    homepage = "https://github.com/FigBug/LoserPorts";
    platforms = [ "x86_64-linux" ];
    license = [ lib.licenses.bsd3 ];
    maintainers = [ lib.maintainers.mrtnvgr ];
  };
}
