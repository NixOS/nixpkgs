{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
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

  buildVST3 ? true,
  buildCLAP ? true,
  buildAU ? stdenv.hostPlatform.isDarwin,
  buildLV2 ? stdenv.hostPlatform.isLinux,
}:

let
  formats = lib.concatStringsSep " " [
    (lib.optionalString buildVST3 "VST3")
    (lib.optionalString buildLV2 "LV2")
    (lib.optionalString buildAU "AU")
  ];
in

stdenv.mkDerivation (finalAttrs: {
  pname = "SG-323";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "greyboxaudio";
    repo = "SG-323";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-yAC4YQt8f5kQ03ECAxvoM9wcqna98F4XKcwUQg6l4E0=";
  };

  patches = [
    # Adds BUILD_CLAP option
    (fetchpatch {
      url = "https://github.com/greyboxaudio/SG-323/pull/26.patch";
      hash = "sha256-k1KY6elA6sajVLgI2omW9LpMdB5RtKA4NsE/G/b/SdM=";
    })
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "FORMATS VST3 AAX AU LV2" "FORMATS ${formats}"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
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

  cmakeFlags = [
    (lib.cmakeBool "BUILD_CLAP" buildCLAP)
  ];

  enableParallelBuilding = true;

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

  installPhase =
    let
      vst3Dir =
        if stdenv.hostPlatform.isDarwin then "$out/Library/Audio/Plug-Ins/VST3" else "$out/lib/vst3";
      # this one's a guess, don't know where ppl have agreed to put them yet
      clapDir =
        if stdenv.hostPlatform.isDarwin then "$out/Library/Audio/Plug-Ins/CLAP" else "$out/lib/clap";
      auDir = "$out/Library/Audio/Plug-Ins/Components";
    in
    ''
      runHook preInstall

      ${lib.optionalString buildAU ''
        mkdir -p ${auDir}
        cp -r "SG323_artefacts/Release/AU/SG-323.component" ${auDir}
      ''}

      ${lib.optionalString buildLV2 ''
        mkdir -p $out/lib/lv2
        cp -r "SG323_artefacts/Release/LV2/SG-323.lv2" $out/lib/lv2
      ''}

      ${lib.optionalString buildVST3 ''
        mkdir -p ${vst3Dir}
        mv SG323_artefacts/Release/VST3/* ${vst3Dir}
      ''}

      ${lib.optionalString buildCLAP ''
        mkdir -p ${clapDir}
        mv SG323_artefacts/Release/CLAP/* ${clapDir}
      ''}

      runHook postInstall
    '';

  meta = {
    description = "Ursa Major Stargate 323 reverb plugin";
    homepage = "https://github.com/greyboxaudio/SG-323";
    changelog = "https://github.com/greyboxaudio/SG-323/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ magnetophon ];
    platforms = lib.platforms.all;
  };
})
