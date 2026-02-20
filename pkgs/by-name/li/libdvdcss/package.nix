{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libdvdcss";
  version = "1.4.3";

  src = fetchurl {
    url = "http://get.videolan.org/libdvdcss/${finalAttrs.version}/libdvdcss-${finalAttrs.version}.tar.bz2";
    sha256 = "sha256-IzzJL13AHF06lvWzWCvn1c7lo1pS06CBWHRdPYYHAHk=";
  };

  meta = {
    homepage = "http://www.videolan.org/developers/libdvdcss.html";
    description = "Library for decrypting DVDs";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
  };
})
