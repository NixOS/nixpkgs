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
  version = "0.94-unstable-2024-08-12";

  src = fetchFromGitHub {
    owner = "CCExtractor";
    repo = "ccextractor";
    rev = "92f2ce0fa026b01fb07db6751210e6bd8c8944d3";
    hash = "sha256-bp7T9uJK4bauR2Co4lKqqnM6oGa3WZ+1toEKmzOx4mI=";
  };

  patches = [
    ./remove-default-commit-hash.patch
    ./remove-vendored-libraries.patch
  ] ++ finalAttrs.cargoDeps.patches;

  cmakeDir = "../src";

  cargoRoot = "src/rust";

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit (finalAttrs) src;
    sourceRoot = "${finalAttrs.src.name}/${finalAttrs.cargoRoot}";
    patches = [ ./use-rsmpeg-0.15.patch ];
    patchFlags = [ "-p3" ];
    hash = "sha256-jh8hHKAad+tCJGwuGdoJp/TMm/IsMrZmz8aag9lj0BA=";
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

  buildInputs =
    [
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

  cmakeFlags =
    [
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
