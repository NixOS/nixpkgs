{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  alsa-lib,
  fontconfig,
  freetype,
  libx11,
  libxcomposite,
  libxcursor,
  libxdmcp,
  libxext,
  libxinerama,
  libxrandr,
  libxtst,
  writableTmpDirAsHomeHook,

  buildVST3 ? true,
  buildLV2 ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gate12";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "tiagolr";
    repo = "gate12";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-dyeIWD315+aKZRwtkRYaWNOS8bNDFboMVPHHe7l+IIY=";
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
    libx11
    libxcomposite
    libxcursor
    libxdmcp
    libxext
    libxinerama
    libxrandr
    libxtst
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

    pushd GATE12_artefacts/Release
      ${lib.optionalString buildVST3 ''
        mkdir -p $out/lib/vst3
        cp -r VST3/GATE-12.vst3 $out/lib/vst3
      ''}

      ${lib.optionalString buildLV2 ''
        mkdir -p $out/lib/lv2
        cp -r LV2/GATE-12.lv2 $out/lib/lv2
      ''}
    popd

    runHook postInstall
  '';

  meta = {
    description = "Trance gate / volume shaper";
    homepage = "https://github.com/tiagolr/gate12";
    changelog = "https://github.com/tiagolr/gate12/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      magnetophon
      mrtnvgr
    ];
    platforms = lib.platforms.all;
  };
})
