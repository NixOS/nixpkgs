{
  lib,
  stdenv,
  fetchFromGitHub,
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
  version = "0.94-unstable-2025-05-20";

  src = fetchFromGitHub {
    owner = "CCExtractor";
    repo = "ccextractor";
    rev = "407d0f4e93611c5b0ceb14b7fc01d4a4c2e90433";
    hash = "sha256-BfsQmCNB4HRafqJ3pC2ECiwhOgwKuIqiLjr2/bvHr7Q=";
  };

  patches = [
    ./remove-default-commit-hash.patch
    ./remove-vendored-libraries.patch
  ]
  ++ finalAttrs.cargoDeps.vendorStaging.patches;

  cmakeDir = "../src";

  cargoRoot = "src/rust";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src cargoRoot;
    patches = [ ./use-rsmpeg-0.15.patch ];
    hash = "sha256-68Y8nzPHxhVIRHoPXOy9tc71177lCBuOf//z3cqyDGQ=";
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

    # TODO: This (and the corresponding patch) should probably be
    # removed for the next stable release.
    (lib.cmakeFeature "GIT_COMMIT_HASH" finalAttrs.src.rev)
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
      --replace-fail 'getenv("TESSDATA_PREFIX")' '"${tesseract}/share"'
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
