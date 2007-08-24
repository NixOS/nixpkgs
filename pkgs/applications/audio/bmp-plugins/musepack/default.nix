{stdenv, fetchurl, pkgconfig, bmp, libmpcdec, taglib}:

stdenv.mkDerivation {
  name = "bmp-plugin-musepack-1.2";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://files2.musepack.net/linux/plugins/bmp-musepack-1.2.tar.bz2;
    md5 = "5fe0c9d341ca37d05c780a478f829a5f";
  };
  buildInputs = [pkgconfig bmp libmpcdec taglib];
}
