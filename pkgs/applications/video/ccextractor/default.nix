{ lib, stdenv, fetchFromGitHub, pkgconfig, cmake
, glew, glfw3, zlib, libiconv
, ocrSupport ? true, leptonica ? null, tesseract4 ? null }:

with lib;
stdenv.mkDerivation rec {
  pname = "ccextractor";
  version = "0.88";

  src = fetchFromGitHub {
    owner = "CCExtractor";
    repo = pname;
    rev = "v${version}";
    sha256 = "1sya45hvv4d46bk7541yimmafgvgyhkpsvwfz9kv6pm4yi1lz6nb";
  };

  sourceRoot = "source/src";

  nativeBuildInputs = [ pkgconfig cmake ];

  cmakeFlags = [
    "-DWITH_OCR=${if ocrSupport then "ON" else "OFF"}"
  ];

  buildInputs = [ glew glfw3 zlib ]
    ++ lib.optionals ocrSupport [ leptonica tesseract4 ]
    ++ lib.optional (!stdenv.isLinux) libiconv;

  meta = {
    homepage = "https://www.ccextractor.org";
    description = "Tool that produces subtitles from closed caption data in videos";
    longDescription = ''
      A tool that analyzes video files and produces independent subtitle files from
      closed captions data. CCExtractor is portable, small, and very fast.
      It works on Linux, Windows, and OSX.
    '';
    platforms = platforms.unix;
    license = licenses.gpl2;
    maintainers = with maintainers; [ nilsirl titanous ];
  };
}
