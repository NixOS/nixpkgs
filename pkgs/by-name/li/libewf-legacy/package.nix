{ lib
, fetchurl
, fetchpatch
, stdenv
, zlib
, openssl
, libuuid
, pkg-config
, bzip2
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libewf-legacy";
  version = "20140814";

  src = fetchurl {
    url = "https://github.com/libyal/libewf-legacy/releases/download/${finalAttrs.version}/libewf-${finalAttrs.version}.tar.gz";
    hash = "sha256-OM3QXwnaIDeo66UNjzmu6to53SxgCMn/rE9VTPlX5BQ=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ zlib openssl libuuid ]
    ++ lib.optionals stdenv.isDarwin [ bzip2 ];

  meta = {
    description = "Legacy library for support of the Expert Witness Compression Format";
    homepage = "https://sourceforge.net/projects/libewf/";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ d3vil0p3r ];
    platforms = lib.platforms.unix;
  };
})
