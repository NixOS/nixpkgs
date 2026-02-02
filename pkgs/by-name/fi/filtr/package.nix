{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  alsa-lib,
  fontconfig,
  freetype,
  libX11,
  libXcomposite,
  libXcursor,
  libXdmcp,
  libXext,
  libXinerama,
  libXrandr,
  libXtst,
  writableTmpDirAsHomeHook,

  buildVST3 ? true,
  buildLV2 ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "filtr";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "tiagolr";
    repo = "filtr";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-LRVwJ/Eh+XeNGnlbd2c56hWV8StHZGhxy0XLjGZ0toY=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    writableTmpDirAsHomeHook # fontconfig cache
  ];

  buildInputs = [
    fontconfig
    freetype
  ]
  ++ lib.optionals stdenv.isLinux [
    alsa-lib
    libX11
    libXcomposite
    libXcursor
    libXdmcp
    libXext
    libXinerama
    libXrandr
    libXtst
  ];

  enableParallelBuilding = true;

  cmakeFlags = [
    (lib.cmakeBool "COPY_PLUGIN_AFTER_BUILD" false)

    (lib.cmakeBool "BUILD_STANDALONE" false)
    (lib.cmakeBool "BUILD_VST3" buildVST3)
    (lib.cmakeBool "BUILD_LV2" buildLV2)
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "-DCMAKE_OSX_ARCHITECTURES=${stdenv.hostPlatform.darwinArch}"
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isLinux (toString [
    # juce, compiled in this build as part of a Git submodule, uses `-flto` as
    # a Link Time Optimization flag, and instructs the plugin compiled here to
    # use this flag to. This breaks the build for us. Using _fat_ LTO allows
    # successful linking while still providing LTO benefits. If our build of
    # `juce` was used as a dependency, we could have patched that `-flto` line
    # in our juce's source, but that is not possible because it is used as a
    # Git Submodule.
    "-ffat-lto-objects"
  ]);

  installPhase = ''
    runHook preInstall

    pushd FILTR_artefacts/Release
      ${lib.optionalString buildVST3 ''
        mkdir -p $out/lib/vst3
        cp -r VST3/FILT-R.vst3 $out/lib/vst3
      ''}

      ${lib.optionalString buildLV2 ''
        mkdir -p $out/lib/lv2
        cp -r LV2/FILT-R.lv2 $out/lib/lv2
      ''}
    popd

    runHook postInstall
  '';

  meta = {
    description = "Envelope based filter modulator";
    homepage = "https://github.com/tiagolr/filtr";
    changelog = "https://github.com/tiagolr/filtr/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      magnetophon
      mrtnvgr
    ];
    platforms = lib.platforms.all;
  };
})
