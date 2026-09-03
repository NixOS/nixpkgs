{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  writeTextFile,

  pkg-config,
  cmake,
  ninja,
  cargo,
  rustc,
  corrosion,
  rustPlatform,

  gpac,
  protobufc,
  libpng,
  zlib,
  utf8proc,
  freetype,
  ffmpeg,
  libarchive,
  curl,
  libiconv,

  enableOcr ? true,
  leptonica,
  tesseract,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ccextractor";
  version = "0.96.6";

  src = fetchFromGitHub {
    owner = "CCExtractor";
    repo = "ccextractor";
    rev = "v${finalAttrs.version}";
    hash = "sha256-nvfQX+1pM16ll7ruXcB22fWn2zQvmpUzKhD3vznEcbI=";
  };

  patches = [
    ./remove-vendored-libraries.patch
  ]
  ++ finalAttrs.cargoDeps.vendorStaging.patches;

  cmakeDir = "../src";

  cargoRoot = "src/rust";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src cargoRoot;
    hash = "sha256-0FPxU3rUoT3/Xy3mQjjQGmxkNjs++sQxjCJ1/UuRQlc=";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
    ninja
    cargo
    rustc
    corrosion
    rustPlatform.cargoSetupHook
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    gpac
    protobufc
    libpng
    zlib
    utf8proc
    freetype
    ffmpeg
    libarchive
    curl
    libiconv
  ]
  ++ lib.optionals enableOcr [
    leptonica
    tesseract
  ];

  cmakeFlags = [
    # The tests are all part of one `cargo test` invocation, so let’s
    # get the output from it.
    (lib.cmakeFeature "CMAKE_CTEST_ARGUMENTS" "--verbose")
  ]
  ++ lib.optionals enableOcr [
    (lib.cmakeBool "WITH_OCR" true)
    (lib.cmakeBool "WITH_HARDSUBX" true)
  ];

  env = {
    FFMPEG_INCLUDE_DIR = "${lib.getDev ffmpeg}/include";

    # Upstream’s FFmpeg binding crate needs an explicit path to a shared
    # object to do dynamic linking. The key word is *an* explicit path;
    # they don’t support passing more than one. This linker script hack
    # pulls in all the FFmpeg libraries they bind to.
    #
    # See: <https://github.com/CCExtractor/rusty_ffmpeg/pull/69>
    FFMPEG_DLL_PATH =
      let
        ffmpegLibNames = [
          "avcodec"
          "avdevice"
          "avfilter"
          "avformat"
          "avutil"
          "swresample"
          "swscale"
        ];
        ffmpegLibDir = "${lib.getLib ffmpeg}/lib";
        ffmpegLibExt = stdenv.hostPlatform.extensions.library;
        ffmpegLibPath = ffmpegLibName: "${ffmpegLibDir}/lib${ffmpegLibName}.${ffmpegLibExt}";
        ffmpegLinkerScript = writeTextFile {
          name = "ccextractor-ffmpeg-linker-script";
          destination = "/lib/ffmpeg.ld";
          text = "INPUT(${lib.concatMapStringsSep " " ffmpegLibPath ffmpegLibNames})";
        };
      in
      "${ffmpegLinkerScript}/lib/ffmpeg.ld";
  };

  doCheck = true;

  postPatch = lib.optionalString enableOcr ''
    substituteInPlace src/lib_ccx/ocr.c \
      --replace-fail 'getenv("TESSDATA_PREFIX")' '"${tesseract}/share/"'
  '';

  meta = {
    homepage = "https://www.ccextractor.org/";
    changelog = "${finalAttrs.src.meta.homepage}/blob/${finalAttrs.src.rev}/docs/CHANGES.TXT";
    description = "Tool that produces subtitles from closed caption data in videos";
    longDescription = ''
      A tool that analyzes video files and produces independent subtitle files from
      closed captions data. CCExtractor is portable, small, and very fast.
      It works on Linux, Windows, and OSX.
    '';
    platforms = lib.platforms.unix;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.emily ];
    mainProgram = "ccextractor";
  };
})
