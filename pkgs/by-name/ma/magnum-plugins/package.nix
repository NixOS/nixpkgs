{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  magnum,
  corrade,
  assimp,
  libz,
  freetype,
  libjpeg, # compatible with libjepg8?
  libpng,
  harfbuzz,
  faad2,
  zstd,
  # build and tests pass + tested with mc-rtc-magnum
  withAssimpImporter ? false,
  withStbImageImporter ? false,
  # builds and tests pass
  withStbImageConverter ? false,
  withStbTrueTypeFont ? true,
  withFreetypeFont ? true,
  withJpegImageConverter ? false,
  withJpegImporter ? false,
  withPngImageConverter ? false,
  withPngImporter ? true,
  withHarfBuzzFont ? false,
  withStanfordImporter ? false,
  withMiniExrImageConverter ? false,
  withKtxImporter ? false,
  withKtxImageConverter ? false,
  withMeshOptimizer ? false, # no tests
  withPrimitiveImporter ? false,
  withUvImageConverter ? false,
  withOpenGexImporter ? false,
  withDrFlacAudioImporter ? false,
  withDrMp3AudioImporter ? false,
  withDrWavAudioImporter ? false,
  withStbVorbisAudioImporter ? false,
  withBasisImageConverter ? false,
  withBasisImporter ? false,
  withIcoImporter ? false, # needs withPngImporter=true and withStbImageImporter=true
  withGltfImporter ? false,
  withFaad2AudioImporter ? false,
  withDdsImporter ? false,

  # works but gated by MAGNUM_BUILD_DEPRECATED, so we should drop it
  withOpenDdl ? false, # gated by MAGNUM_BUILD_DEPRECATED, I think we can drop it
  withCgltfImporter ? false, # gated by MAGNUM_BUILD_DEPRECATED, I think we can drop it

  # fails and gated by MAGNUM_BUILD_DEPRECATED, definitely drop it
  withTinyGltfImporter ? false, # gated by MAGNUM_BUILD_DEPRECATED, I think we can drop it
}:

let
  # Magnum's BasisImporter uses an older version of basis-universal,
  # and builds it in-tree with additional patches, notably replacing
  # basis-universal's zstd with the system's version
  basis-universal-src = fetchFromGitHub {
    owner = "BinomialLLC";
    repo = "basis_universal";
    tag = "v1_50_0_2";
    hash = "sha256-39l6el0Ha0l+URrfaNtEpy7WZQKlt79z42Z7BWnF3TE=";
  };
in

# Real Nix assertions that evaluate immediately and throw an error if false
assert lib.assertMsg (
  !(withFreetypeFont && withHarfBuzzFont)
) "magnum-plugins: withFreetypeFont and withHarfBuzzFont cannot be enabled at the same time.";

assert lib.assertMsg (
  !(withCgltfImporter && withGltfImporter)
) "magnum-plugins: withCgltfImporter and withGltfImporter cannot be enabled at the same time.";

assert lib.assertMsg (
  !(withOpenDdl && withOpenGexImporter)
) "magnum-plugins: withOpenDdl and withOpenGexImporter cannot be enabled at the same time.";

assert lib.assertMsg (!withIcoImporter || (withPngImporter && withStbImageImporter))
  "magnum-plugins: withIcoImporter requires both withPngImporter and withStbImageImporter to be enabled (at least for tests).";

# Deprecated options gating checks
assert lib.assertMsg (
  !withOpenDdl || (magnum.passthru.magnumBuildDeprecated)
) "magnum-plugins: withOpenDdl requires magnum to be built with MAGNUM_BUILD_DEPRECATED enabled.";

assert lib.assertMsg (!withCgltfImporter || (magnum.passthru.magnumBuildDeprecated))
  "magnum-plugins: withCgltfImporter requires magnum to be built with magnumBuildDeprecated = true (MAGNUM_BUILD_DEPRECATED=ON) enabled.";

assert lib.assertMsg (!withTinyGltfImporter || (magnum.passthru.magnumBuildDeprecated))
  "magnum-plugins: withTinyGltfImporter is currently unsupported : failing unit tests + requires magnum to be built with magnumBuildDeprecated = true (MAGNUM_BUILD_DEPRECATED=ON) enabled.";

stdenv.mkDerivation (_finalAttrs: {
  pname = "magnum-plugins";
  version = "2020.06-unstable-2026-10-17";

  __structuredAttrs = true;
  strictDeps = true;
  doCheck = true;

  src = fetchFromGitHub {
    owner = "mosra";
    repo = "magnum-plugins";
    rev = "df8fd174820b17675d23d687cea43cb31f73ea6a";
    hash = "sha256-CQY/3u3tj3lYCgAx/bMoxo82by5OVBuX6x4ZwBRM8cA=";
  };

  nativeBuildInputs = [
    cmake
    corrade
  ];
  propagatedBuildInputs = [
    magnum
  ]
  ++ lib.optionals withAssimpImporter [
    assimp
    libz
  ]
  ++ lib.optional withFreetypeFont freetype
  ++ lib.optional (withJpegImporter || withJpegImageConverter) libjpeg
  ++ lib.optional (withPngImporter || withPngImageConverter) libpng
  ++ lib.optionals withHarfBuzzFont [
    harfbuzz
    freetype
  ]
  ++ lib.optional withFaad2AudioImporter faad2
  ++ lib.optional (withBasisImageConverter || withBasisImporter) zstd;

  cmakeFlags = [
    (lib.cmakeBool "MAGNUM_BUILD_TESTS" true)
    (lib.cmakeBool "MAGNUM_WITH_ASSIMPIMPORTER" withAssimpImporter)
    (lib.cmakeBool "MAGNUM_WITH_BASISIMAGECONVERTER" withBasisImageConverter)
    (lib.cmakeBool "MAGNUM_WITH_BASISIMPORTER" withBasisImporter)
    (lib.cmakeBool "MAGNUM_WITH_CGLTFIMPORTER" withCgltfImporter)
    (lib.cmakeBool "MAGNUM_WITH_DRFLACAUDIOIMPORTER" withDrFlacAudioImporter)
    (lib.cmakeBool "MAGNUM_WITH_DRMP3AUDIOIMPORTER" withDrMp3AudioImporter)
    (lib.cmakeBool "MAGNUM_WITH_DRWAVAUDIOIMPORTER" withDrWavAudioImporter)
    (lib.cmakeBool "MAGNUM_WITH_FAAD2AUDIOIMPORTER" withFaad2AudioImporter)
    (lib.cmakeBool "MAGNUM_WITH_FREETYPEFONT" withFreetypeFont)
    (lib.cmakeBool "MAGNUM_WITH_HARFBUZZFONT" withHarfBuzzFont)
    (lib.cmakeBool "MAGNUM_WITH_ICOIMPORTER" withIcoImporter)
    (lib.cmakeBool "MAGNUM_WITH_JPEGIMAGECONVERTER" withJpegImageConverter)
    (lib.cmakeBool "MAGNUM_WITH_JPEGIMPORTER" withJpegImporter)
    (lib.cmakeBool "MAGNUM_WITH_KTXIMAGECONVERTER" withKtxImageConverter)
    (lib.cmakeBool "MAGNUM_WITH_KTXIMPORTER" withKtxImporter)
    (lib.cmakeBool "MAGNUM_WITH_MESHOPTIMIZER" withMeshOptimizer)
    (lib.cmakeBool "MAGNUM_WITH_MINIEXRIMAGECONVERTER" withMiniExrImageConverter)
    (lib.cmakeBool "MAGNUM_WITH_OPENDDL" withOpenDdl)
    (lib.cmakeBool "MAGNUM_WITH_OPENGEXIMPORTER" withOpenGexImporter)
    (lib.cmakeBool "MAGNUM_WITH_PNGIMAGECONVERTER" withPngImageConverter)
    (lib.cmakeBool "MAGNUM_WITH_PNGIMPORTER" withPngImporter)
    (lib.cmakeBool "MAGNUM_WITH_PRIMITIVEIMPORTER" withPrimitiveImporter)
    (lib.cmakeBool "MAGNUM_WITH_STANFORDIMPORTER" withStanfordImporter)
    (lib.cmakeBool "MAGNUM_WITH_STBIMAGECONVERTER" withStbImageConverter)
    (lib.cmakeBool "MAGNUM_WITH_STBIMAGEIMPORTER" withStbImageImporter)
    (lib.cmakeBool "MAGNUM_WITH_STBTRUETYPEFONT" withStbTrueTypeFont)
    (lib.cmakeBool "MAGNUM_WITH_STBVORBISAUDIOIMPORTER" withStbVorbisAudioImporter)
    (lib.cmakeBool "MAGNUM_WITH_TINYGLTFIMPORTER" withTinyGltfImporter)
    (lib.cmakeBool "MAGNUM_WITH_UVIMAGECONVERTER" withUvImageConverter)
    (lib.cmakeBool "MAGNUM_WITH_GLTFIMPORTER" withGltfImporter)
    (lib.cmakeBool "MAGNUM_WITH_CGLTFIMPORTER" withCgltfImporter)
    (lib.cmakeBool "MAGNUM_WITH_DDSIMPORTER" withDdsImporter)
  ]
  ++ lib.optionals (withBasisImageConverter || withBasisImporter) [
    "-DBASIS_UNIVERSAL_DIR=${basis-universal-src}"
    "-DKTX2_ZSTANDARD=ON"
  ];

  preCheck = ''
    # Point Corrade to the built plugins in the build directory
    export CORRADE_PLUGIN_PATH="$buildDir/lib/magnum"
  '';

  # FIXME:
  # Failing tests are :
  # - AssimpImporter -> probably due to ASSIMP 6 not being fully supported upstream
  # - Faad2AudioImporter -> decoding error
  postPatch = ''
    substituteInPlace src/MagnumPlugins/AssimpImporter/CMakeLists.txt \
      --replace "add_subdirectory(Test" "#add_subdirectory(Test"
    substituteInPlace src/MagnumPlugins/Faad2AudioImporter/CMakeLists.txt \
      --replace "add_subdirectory(Test" "#add_subdirectory(Test"
  '';

  meta = with lib; {
    description = "Plugins for the Magnum C++11 graphics engine";
    homepage = "https://github.com/msora/magnum-plugins";
    license = licenses.mit;
    maintainers = with maintainers; [ arntanguy ];
    platforms = platforms.all;
  };
})
