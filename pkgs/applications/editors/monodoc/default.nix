{stdenv, fetchurl, mono, gtksharp, pkgconfig}:

stdenv.mkDerivation {
  name = "monodoc-1.0.6";

  src = fetchurl {
    url = http://www.go-mono.com/archive/1.0.6/monodoc-1.0.6.tar.gz;
    md5 = "f2fc27e8e4717d90dc7efa2450625693";
  };

  buildInputs = [mono gtksharp pkgconfig];
}
