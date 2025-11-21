{
  stdenv,
  lib,
  fetchFromGitHub,
  nix-update-script,
  cmake,
  pkg-config,
  writableTmpDirAsHomeHook,
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
}:
stdenv.mkDerivation (finalAttrs: {
  name = "reevr";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "tiagolr";
    repo = "reevr";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-2JGBDYyxXIGM+8/T6srGn81YbhhknAHKbVllz1jIwOY=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    writableTmpDirAsHomeHook
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

  # Fontconfig error: Cannot load default config file: No such file: (null)
  env.FONTCONFIG_FILE = "${fontconfig.out}/etc/fonts/fonts.conf";

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "juce::juce_recommended_lto_flags" "# Not forcing LTO"

    substituteInPlace CMakeLists.txt \
      --replace-fail "COPY_PLUGIN_AFTER_BUILD TRUE" "COPY_PLUGIN_AFTER_BUILD FALSE"
  '';

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_AR" (lib.getExe' stdenv.cc.cc "gcc-ar"))
    (lib.cmakeFeature "CMAKE_RANLIB" (lib.getExe' stdenv.cc.cc "gcc-ranlib"))
    (lib.cmakeBool "BUILD_STANDALONE" buildStandalone)
  ];

  installPhase = ''
    runHook preInstall

    pushd REEVR_artefacts/Release
      ${lib.optionalString buildStandalone ''
        install -Dm755 Standalone/REEV-R -t $out/bin
      ''}

      mkdir -p $out/lib/{vst3,lv2}
      cp -r VST3/REEV-R.vst3 $out/lib/vst3
      cp -r LV2/REEV-R.lv2 $out/lib/lv2
    popd

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Convolution reverb with pre and post modulation";
    homepage = "https://github.com/tiagolr/reevr";
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.mrtnvgr ];
    mainProgram = lib.optionalString buildStandalone "REEV-R";
  };
})
