{stdenv, fetchurl}: stdenv.mkDerivation {
  name = "cua-mode-2.10";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/cua-mode-2.10.el;
    md5 = "5bf5e43f5f38c8383868c7c6c5baca09";
  };
}
