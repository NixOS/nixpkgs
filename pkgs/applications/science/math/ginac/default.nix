{ stdenv, fetchurl, cln, pkgconfig, readline, gmp, python }:

stdenv.mkDerivation rec {
  name = "ginac-1.7.2";

  src = fetchurl {
    url    = "${meta.homepage}/${name}.tar.bz2";
    sha256 = "1dyq47gc97jn1r5sy0klxs5b4lzhckyjqgsvwcs2a9ybqmhmpdr4";
  };

  propagatedBuildInputs = [ cln ];

  buildInputs = [ readline ] ++ stdenv.lib.optional stdenv.isDarwin gmp;

  nativeBuildInputs = [ pkgconfig python ];

  preConfigure = "patchShebangs ginsh";

  configureFlags = "--disable-rpath";

  meta = with stdenv.lib; {
    description = "GiNaC is Not a CAS";
    homepage    = http://www.ginac.de/;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.all;
  };
}
