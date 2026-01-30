{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,

  bzip2,
  curl,
  fribidi,
  gtk3,
  iconv,
  libcpuid,
  libjpeg,
  libpng,
  libwebp,
  libxml2,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "smooth";
  version = "0.9.10";

  src = fetchFromGitHub {
    owner = "enzo1982";
    repo = "smooth";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-J2Do1iAbE1GBC8co/4nxOzeGJQiPRc+21fgMDpzKX+A=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  makeFlags = [
    "prefix=$(out)"
    "config=systemlibbz2,systemlibcpuid,systemlibcurl,systemlibfribidi,systemlibiconv,systemlibjpeg,systemlibpng,systemlibwebp,systemlibxml2,systemzlib"
  ];

  buildInputs = [
    bzip2
    curl
    fribidi
    gtk3
    iconv
    libcpuid
    libjpeg
    libpng
    libwebp
    libxml2
    zlib
  ];

  meta = {
    description = "Object-oriented class library for C++ application development";
    mainProgram = "smooth-translator";
    license = lib.licenses.artistic2;
    homepage = "http://www.smooth-project.org/";
    platforms = lib.platforms.linux;
  };
})
