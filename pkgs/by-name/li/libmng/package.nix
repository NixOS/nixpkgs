{
  lib,
  stdenv,
  fetchurl,
  zlib,
  libpng,
  libjpeg,
  lcms2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libmng";
  version = "2.0.3";

  src = fetchurl {
    url = "mirror://sourceforge/libmng/libmng-${finalAttrs.version}.tar.xz";
    sha256 = "1lvxnpds0vcf0lil6ia2036ghqlbl740c4d2sz0q5g6l93fjyija";
  };

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];
  outputMan = "devdoc";

  propagatedBuildInputs = [
    zlib
    libpng
    libjpeg
    lcms2
  ];

  meta = {
    description = "Reference library for reading, displaying, writing and examining Multiple-Image Network Graphics";
    homepage = "http://www.libmng.com";
    license = lib.licenses.zlib;
    maintainers = with lib.maintainers; [ marcweber ];
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };
})
