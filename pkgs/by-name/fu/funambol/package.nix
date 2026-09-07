{
  lib,
  stdenv,
  fetchurl,
  zlib,
  curl,
  autoreconfHook,
  unzip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "funambol-client-cpp";
  version = "9.0.0";

  src = fetchurl {
    url = "mirror://sourceforge/funambol/funambol-client-sdk-${finalAttrs.version}.zip";
    sha256 = "1667gahz30i5r8kbv7w415z0hbgm6f6pln1137l5skapi1if6r73";
  };

  postUnpack = ''sourceRoot+="/sdk/cpp/build/autotools"'';

  propagatedBuildInputs = [
    zlib
    curl
  ];

  nativeBuildInputs = [
    autoreconfHook
    unzip
  ];

  meta = {
    description = "SyncML client sdk by Funambol project";
    homepage = "https://www.funambol.com";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.unix;
  };
})
