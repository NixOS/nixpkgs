{stdenv, fetchurl, mono, gtksharp, pkgconfig, makeWrapper}:

stdenv.mkDerivation {
  name = "monodoc-1.0.6";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://nixos.org/tarballs/monodoc-1.0.6.tar.gz;
    md5 = "f2fc27e8e4717d90dc7efa2450625693";
  };

  buildInputs = [mono gtksharp pkgconfig];

  inherit gtksharp makeWrapper;
}
