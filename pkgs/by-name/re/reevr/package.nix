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
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "reevr";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "tiagolr";
    repo = "reevr";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-uOaImmc8MXhH6P3IN53LGntsWAbsVnqkz8TUk67aYcU=";
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
    (lib.cmakeFeature "BUILD_STANDALONE" "OFF")
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    (lib.cmakeFeature "CMAKE_OSX_ARCHITECTURES" "${stdenv.hostPlatform.darwinArch}")
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

    mkdir -p $out/lib/vst3 $out/lib/lv2

    cp -r "REEVR_artefacts/Release/LV2/REEV-R.lv2" $out/lib/lv2
    cp -r "REEVR_artefacts/Release/VST3/REEV-R.vst3" $out/lib/vst3

    runHook postInstall
  '';

  meta = {
    description = "Convolution reverb with pre and post modulation";
    homepage = "https://github.com/tiagolr/reevr";
    changelog = "https://github.com/tiagolr/reevr/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ magnetophon ];
    platforms = lib.platforms.all;
  };
})
