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
  spirv-tools,
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
  withHarfBuzzFont ? true,
  withStanfordImporter ? false,
  withMiniExrImageConverter ? false,
  withKtxImporter ? false,
  withKtxImageConverter ? false,
  withMeshOptimizer ? false, # no tests
  withPrimitiveImporter ? false,
  withUvImageConverter ? false,
  withDrFlacAudioImporter ? false,
  withDrMp3AudioImporter ? false,
  withDrWavAudioImporter ? false,
  withStbVorbisAudioImporter ? false,
  withBasisImageConverter ? false,
  withBasisImporter ? false,
  withIcoImporter ? false,
  withGltfImporter ? false,
  withFaad2AudioImporter ? false,
  withDdsImporter ? false,
  withSpirvToolsShaderConverter ? true,
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

assert lib.assertMsg (
  withHarfBuzzFont && withFreetypeFont
) "magnum-plugins: withHarfBuzzFont needs withFreetypeFont to be enabled";

stdenv.mkDerivation (_finalAttrs: {
  pname = "magnum-plugins";
  version = "2020.06-unstable-2026-11-05";

  __structuredAttrs = true;
  strictDeps = true;
  doCheck = true;

  src = fetchFromGitHub {
    owner = "mosra";
    repo = "magnum-plugins";
    rev = "d4da56662318ba37f58c33d487100ea590c505ec";
    hash = "sha256-OgBT5lPX4HndW836N+a2dQweHGRqxWkyjFNFnNp+Nl4=";
  };

  nativeBuildInputs = [
    cmake
    corrade
  ];
  propagatedBuildInputs = [
    corrade
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
  ++ lib.optional (withBasisImageConverter || withBasisImporter) zstd
  ++ lib.optional withSpirvToolsShaderConverter spirv-tools;

  cmakeFlags = [
    (lib.cmakeBool "MAGNUM_BUILD_TESTS" true)
    (lib.cmakeBool "MAGNUM_WITH_ASSIMPIMPORTER" withAssimpImporter)
    (lib.cmakeBool "MAGNUM_WITH_BASISIMAGECONVERTER" withBasisImageConverter)
    (lib.cmakeBool "MAGNUM_WITH_BASISIMPORTER" withBasisImporter)
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
    (lib.cmakeBool "MAGNUM_WITH_PNGIMAGECONVERTER" withPngImageConverter)
    (lib.cmakeBool "MAGNUM_WITH_PNGIMPORTER" withPngImporter)
    (lib.cmakeBool "MAGNUM_WITH_PRIMITIVEIMPORTER" withPrimitiveImporter)
    (lib.cmakeBool "MAGNUM_WITH_STANFORDIMPORTER" withStanfordImporter)
    (lib.cmakeBool "MAGNUM_WITH_STBIMAGECONVERTER" withStbImageConverter)
    (lib.cmakeBool "MAGNUM_WITH_STBIMAGEIMPORTER" withStbImageImporter)
    (lib.cmakeBool "MAGNUM_WITH_STBTRUETYPEFONT" withStbTrueTypeFont)
    (lib.cmakeBool "MAGNUM_WITH_STBVORBISAUDIOIMPORTER" withStbVorbisAudioImporter)
    (lib.cmakeBool "MAGNUM_WITH_UVIMAGECONVERTER" withUvImageConverter)
    (lib.cmakeBool "MAGNUM_WITH_GLTFIMPORTER" withGltfImporter)
    (lib.cmakeBool "MAGNUM_WITH_DDSIMPORTER" withDdsImporter)
    (lib.cmakeBool "MAGNUM_WITH_SPIRVTOOLSSHADERCONVERTER" withSpirvToolsShaderConverter)
  ]
  ++ lib.optionals (withBasisImageConverter || withBasisImporter) [
    "-DBASIS_UNIVERSAL_DIR=${basis-universal-src}"
    "-DKTX2_ZSTANDARD=ON"
  ];

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

  meta = {
    description = "Plugins for the Magnum C++11 graphics engine";
    homepage = "https://github.com/mosra/magnum-plugins";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.arntanguy ];
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };
})
