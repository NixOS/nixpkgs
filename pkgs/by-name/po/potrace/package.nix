{
  lib,
  stdenv,
  fetchurl,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "potrace";
  version = "1.16";

  src = fetchurl {
    url = "https://potrace.sourceforge.net/download/${finalAttrs.version}/potrace-${finalAttrs.version}.tar.gz";
    sha256 = "1k3sxgjqq0jnpk9xxys05q32sl5hbf1lbk1gmfxcrmpdgnhli0my";
  };

  configureFlags = [ "--with-libpotrace" ];

  buildInputs = [ zlib ];

  enableParallelBuilding = true;
  doCheck = true;

  meta = {
    homepage = "https://potrace.sourceforge.net/";
    description = "Tool for tracing a bitmap, which means, transforming a bitmap into a smooth, scalable image";
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.pSub ];
    license = lib.licenses.gpl2;
  };
})
