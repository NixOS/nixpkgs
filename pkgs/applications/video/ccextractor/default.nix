{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, cmake
, libiconv
, zlib
, enableOcr ? true
, makeWrapper
, tesseract4
, leptonica
, ffmpeg_4
}:

stdenv.mkDerivation rec {
  pname = "ccextractor";
  version = "0.93";

  src = fetchFromGitHub {
    owner = "CCExtractor";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-usVAKBkdd8uz9cD5eLd0hnwGonOJLscRdc+iWDlNXVc=";
  };

  postPatch = ''
    # https://github.com/CCExtractor/ccextractor/issues/1467
    sed -i '/allheaders.h/a#include <leptonica/pix_internal.h>' src/lib_ccx/ocr.c
  '' + lib.optionalString stdenv.isDarwin ''
    substituteInPlace src/CMakeLists.txt \
    --replace 'add_definitions(-DGPAC_CONFIG_LINUX)' 'add_definitions(-DGPAC_CONFIG_DARWIN)'
  '';

  cmakeDir = "../src";

  nativeBuildInputs = [ pkg-config cmake makeWrapper ];

  buildInputs = [ zlib ]
    ++ lib.optional (!stdenv.isLinux) libiconv
    ++ lib.optionals enableOcr [ leptonica tesseract4 ffmpeg_4 ];

  cmakeFlags = [
    # file RPATH_CHANGE could not write new RPATH:
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
  ] ++ lib.optionals enableOcr [ "-DWITH_OCR=on" "-DWITH_HARDSUBX=on" ];

  postInstall = lib.optionalString enableOcr ''
    wrapProgram "$out/bin/ccextractor" \
      --set TESSDATA_PREFIX "${tesseract4}/share/"
  '';

  meta = with lib; {
    homepage = "https://www.ccextractor.org";
    description = "Tool that produces subtitles from closed caption data in videos";
    longDescription = ''
      A tool that analyzes video files and produces independent subtitle files from
      closed captions data. CCExtractor is portable, small, and very fast.
      It works on Linux, Windows, and OSX.
    '';
    platforms = platforms.unix;
    # undefined reference to `png_do_expand_palette_rgba8_neon'
    # undefined reference to `png_riffle_palette_neon'
    # undefined reference to `png_do_expand_palette_rgb8_neon'
    # undefined reference to `png_init_filter_functions_neon'
    # during Linking C executable ccextractor
    broken = stdenv.isAarch64;
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ titanous ];
    mainProgram = "ccextractor";
  };
}
