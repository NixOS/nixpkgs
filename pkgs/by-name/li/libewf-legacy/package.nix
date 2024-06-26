{
  lib,
  fetchurl,
  stdenv,
  zlib,
  openssl,
  libuuid,
  pkg-config,
  bzip2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libewf-legacy";
  version = "20140816";

  src = fetchurl {
    url = "https://github.com/libyal/libewf-legacy/releases/download/${finalAttrs.version}/libewf-${finalAttrs.version}.tar.gz";
    hash = "sha256-ay0Hj7OGFnm6g5Qv6lHp5gKcN+wuoMN/V0QlbW9wJak=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    zlib
    openssl
    libuuid
  ] ++ lib.optionals stdenv.isDarwin [ bzip2 ];

  meta = {
    description = "Legacy library for support of the Expert Witness Compression Format";
    homepage = "https://sourceforge.net/projects/libewf/";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ d3vil0p3r ];
    platforms = lib.platforms.unix;
  };
})
