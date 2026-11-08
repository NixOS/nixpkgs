{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,

  # keep-sorted start case=no numeric=no block=yes
  assimp,
  corrade,
  faad2,
  freetype,
  glslang,
  harfbuzz,
  libavif,
  libjpeg,
  libpng,
  libspng,
  libwebp,
  libz,
  lunasvg,
  magnum,
  meshoptimizer,
  openexr,
  plutosvg,
  resvg,
  spirv-tools,
  zstd,
  # keep-sorted end

  # keep-sorted start case=no numeric=no block=yes
  withAssimpImporter ? true,
  withAstcImporter ? false,
  withAvifImporter ? false,
  withBasisImageConverter ? false,
  withBasisImporter ? false,
  withBcdeImageConverter ? false,
  withDdsImporter ? true,
  withDrFlacAudioImporter ? false,
  withDrMp3AudioImporter ? false,
  withDrWavAudioImporter ? true,
  withEtcDecImageConverter ? false,
  withFaad2AudioImporter ? false,
  withFreetypeFont ? false,
  withGlslangShaderConverter ? false,
  withGltfImporter ? true,
  withGltfSceneConverter ? true,
  withHarfBuzzFont ? false,
  withIcoImporter ? false,
  withJpegImageConverter ? true,
  withJpegImporter ? true,
  withKtxImageConverter ? false,
  withKtxImporter ? false,
  withLunaSvgImporter ? false,
  withMeshOptimizerSceneConverter ? false,
  withMiniExrImageConverter ? false,
  withOpenExrImageConverter ? true,
  withOpenExrImporter ? true,
  withPlutoSvgImporter ? false,
  withPngImageConverter ? true,
  withPngImporter ? true,
  withPrimitiveImporter ? false,
  withResvgImporter ? false,
  withSpirvToolsShaderConverter ? true,
  withSpngImporter ? false,
  withStanfordImporter ? false,
  withStanfordSceneConverter ? false,
  withStbdxImageConverter ? false,
  withStbImageConverter ? true,
  withStbImageImporter ? true,
  withStbResizeImageConverter ? false,
  withStbTrueTypeFont ? true,
  withStbVorbisAudioImporter ? true,
  withUfbxImporter ? false,
  withWebpImageConverter ? true,
  withWebpImporter ? true,
  # keep-sorted end

  # Not supported yet
  withDevilImageImporter ? false, # XXX devil dependency missing https://openil.sourceforge.net/
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
  !(withHarfBuzzFont && withFreetypeFont)
) "magnum-plugins: withHarfBuzzFont needs withFreetypeFont to be enabled";

stdenv.mkDerivation (_finalAttrs: {
  pname = "magnum-plugins";
  version = "2020.06-unstable-2026-11-07";

  __structuredAttrs = true;
  strictDeps = true;
  doCheck = true;

  src = fetchFromGitHub {
    owner = "mosra";
    repo = "magnum-plugins";
    rev = "b99e314c51ed2e47eb408d6b921f802d90102ecb";
    hash = "sha256-dMCWKFXZHtrX/ybVXXfuC4n0vOruHX1H86osLTlYpWM=";
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
  ++ lib.optional withSpirvToolsShaderConverter spirv-tools
  ++ lib.optional withGlslangShaderConverter glslang
  ++ lib.optional withMeshOptimizerSceneConverter meshoptimizer
  ++ lib.optional (withOpenExrImporter || withOpenExrImageConverter) openexr
  ++ lib.optional withResvgImporter resvg
  ++ lib.optional withSpngImporter libspng
  ++ lib.optional withAvifImporter libavif
  ++ lib.optional (withWebpImporter || withWebpImageConverter) libwebp
  ++ lib.optional withPlutoSvgImporter plutosvg
  ++ lib.optional withLunaSvgImporter lunasvg;

  cmakeFlags = [
    # keep-sorted start case=no numeric=no block=yes
    (lib.cmakeBool "MAGNUM_BUILD_TESTS" true)
    (lib.cmakeBool "MAGNUM_WITH_ASSIMPIMPORTER" withAssimpImporter)
    (lib.cmakeBool "MAGNUM_WITH_ASSTCIMPORTER" withAstcImporter)
    (lib.cmakeBool "MAGNUM_WITH_AVIFIMPORTER" withAvifImporter)
    (lib.cmakeBool "MAGNUM_WITH_BASISIMAGECONVERTER" withBasisImageConverter)
    (lib.cmakeBool "MAGNUM_WITH_BASISIMPORTER" withBasisImporter)
    (lib.cmakeBool "MAGNUM_WITH_BCDECIMAGECONVERTER" withBcdeImageConverter)
    (lib.cmakeBool "MAGNUM_WITH_DDSIMPORTER" withDdsImporter)
    (lib.cmakeBool "MAGNUM_WITH_DEVILIMAGEIMPORTER" withDevilImageImporter)
    (lib.cmakeBool "MAGNUM_WITH_DRFLACAUDIOIMPORTER" withDrFlacAudioImporter)
    (lib.cmakeBool "MAGNUM_WITH_DRMP3AUDIOIMPORTER" withDrMp3AudioImporter)
    (lib.cmakeBool "MAGNUM_WITH_DRWAVAUDIOIMPORTER" withDrWavAudioImporter)
    (lib.cmakeBool "MAGNUM_WITH_ETCDECIMAGECONVERTER" withEtcDecImageConverter)
    (lib.cmakeBool "MAGNUM_WITH_FAAD2AUDIOIMPORTER" withFaad2AudioImporter)
    (lib.cmakeBool "MAGNUM_WITH_FREETYPEFONT" withFreetypeFont)
    (lib.cmakeBool "MAGNUM_WITH_GLTFIMPORTER" withGltfImporter)
    (lib.cmakeBool "MAGNUM_WITH_GLTFSCENECONVERTER" withGltfSceneConverter)
    (lib.cmakeBool "MAGNUM_WITH_HARFBUZZFONT" withHarfBuzzFont)
    (lib.cmakeBool "MAGNUM_WITH_ICOIMPORTER" withIcoImporter)
    (lib.cmakeBool "MAGNUM_WITH_JPEGIMAGECONVERTER" withJpegImageConverter)
    (lib.cmakeBool "MAGNUM_WITH_JPEGIMPORTER" withJpegImporter)
    (lib.cmakeBool "MAGNUM_WITH_KTXIMAGECONVERTER" withKtxImageConverter)
    (lib.cmakeBool "MAGNUM_WITH_KTXIMPORTER" withKtxImporter)
    (lib.cmakeBool "MAGNUM_WITH_MESHOPTIMIZERSCENECONVERTER" withMeshOptimizerSceneConverter)
    (lib.cmakeBool "MAGNUM_WITH_MINIEXRIMAGECONVERTER" withMiniExrImageConverter)
    (lib.cmakeBool "MAGNUM_WITH_OPENEXRIMAGECONVERTER" withOpenExrImageConverter)
    (lib.cmakeBool "MAGNUM_WITH_PLUTOSVGIMPORTER" withPlutoSvgImporter)
    (lib.cmakeBool "MAGNUM_WITH_PNGIMAGECONVERTER" withPngImageConverter)
    (lib.cmakeBool "MAGNUM_WITH_PNGIMPORTER" withPngImporter)
    (lib.cmakeBool "MAGNUM_WITH_PRIMITIVEIMPORTER" withPrimitiveImporter)
    (lib.cmakeBool "MAGNUM_WITH_SPIRVTOOLSSHADERCONVERTER" withGlslangShaderConverter)
    (lib.cmakeBool "MAGNUM_WITH_SPIRVTOOLSSHADERCONVERTER" withSpirvToolsShaderConverter)
    (lib.cmakeBool "MAGNUM_WITH_SPNGIMPORTER" withSpngImporter)
    (lib.cmakeBool "MAGNUM_WITH_STANFORDIMPORTER" withStanfordImporter)
    (lib.cmakeBool "MAGNUM_WITH_STANFORDSCENECONVERTER" withStanfordSceneConverter)
    (lib.cmakeBool "MAGNUM_WITH_STBDXIMAGECONVERTER" withStbdxImageConverter)
    (lib.cmakeBool "MAGNUM_WITH_STBIMAGECONVERTER" withStbImageConverter)
    (lib.cmakeBool "MAGNUM_WITH_STBIMAGEIMPORTER" withStbImageImporter)
    (lib.cmakeBool "MAGNUM_WITH_STBRESIZEIMAGECONVERTER" withStbResizeImageConverter)
    (lib.cmakeBool "MAGNUM_WITH_STBTRUETYPEFONT" withStbTrueTypeFont)
    (lib.cmakeBool "MAGNUM_WITH_STBVORBISAUDIOIMPORTER" withStbVorbisAudioImporter)
    (lib.cmakeBool "MAGNUM_WITH_UFBXIMPORTER" withUfbxImporter)
    (lib.cmakeBool "MAGNUM_WITH_WEBPIMAGECONVERTER" withWebpImageConverter)
    (lib.cmakeBool "MAGNUM_WITH_WEBPIMPORTER" withWebpImporter)
    # keep-sorted end
  ]
  ++ lib.optionals (withBasisImageConverter || withBasisImporter) [
    "-DBASIS_UNIVERSAL_DIR=${basis-universal-src}"
    "-DKTX2_ZSTANDARD=ON"
  ];

  # FIXME:
  # Failing tests are :
  # - Faad2AudioImporter -> decoding error
  postPatch = ''
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
