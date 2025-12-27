{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
  libx11,
  libxrandr,
  libxinerama,
  libxext,
  libxcursor,
  freetype,
  fontconfig,
  alsa-lib,
  expat,
  nix-update-script,

  buildVST3 ? true,
  buildLV2 ? true,
  buildCLAP ? true,
}:
let
  formats = lib.concatStringsSep " " [
    (lib.optionalString buildVST3 "VST3")
    (lib.optionalString buildLV2 "LV2")
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "sg-323";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "greyboxaudio";
    repo = "SG-323";
    tag = finalAttrs.version;
    hash = "sha256-DvA9Y7eAG0pWLmHEZmJlo0JLU+0B4c8rlkX1bbVcnL8=";
    fetchSubmodules = true;
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
      --replace-fail "juce::juce_recommended_lto_flags" "# Not enforcing lto" \
      --replace-fail "FORMATS VST3 AAX AU LV2" "FORMATS ${formats}"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libx11
    libxrandr
    libxinerama
    libxext
    libxcursor
    freetype
    fontconfig
    alsa-lib
    expat
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_CLAP" buildCLAP)
  ];

  installPhase = ''
    runHook preInstall

    cd SG323_artefacts/Release

    ${lib.optionalString buildVST3 ''
      mkdir -p $out/lib/vst3
      cp -r VST3/SG-323.vst3 $out/lib/vst3
    ''}

    ${lib.optionalString buildLV2 ''
      mkdir -p $out/lib/lv2
      cp -r LV2/SG-323.lv2 $out/lib/lv2
    ''}

    ${lib.optionalString buildCLAP ''
      mkdir -p $out/lib/clap
      cp -r CLAP/SG-323.clap $out/lib/clap
    ''}

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Ursa Major Stargate 323 emulation plugin";
    homepage = "https://store.greyboxaudio.com/products/sg-323-reverb";
    platforms = lib.platforms.linux;
    license = [ lib.licenses.gpl3Plus ];
    maintainers = [ lib.maintainers.mrtnvgr ];
  };
})
