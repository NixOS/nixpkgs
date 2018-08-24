{ stdenv, fetchurl, cln, pkgconfig, readline, gmp, python }:

stdenv.mkDerivation rec {
  name = "ginac-1.7.4";

  src = fetchurl {
    url    = "${meta.homepage}/${name}.tar.bz2";
    sha256 = "1vvqv73yk9klbq0mz239zzw77rlp72qcvzci4j1v6rafvji1616n";
  };

  propagatedBuildInputs = [ cln ];

  buildInputs = [ readline ] ++ stdenv.lib.optional stdenv.isDarwin gmp;

  nativeBuildInputs = [ pkgconfig python ];

  preConfigure = "patchShebangs ginsh";

  configureFlags = [ "--disable-rpath" ];

  meta = with stdenv.lib; {
    description = "GiNaC is Not a CAS";
    homepage    = http://www.ginac.de/;
    maintainers = with maintainers; [ lovek323 ];
    license = licenses.gpl2;
    platforms   = platforms.all;
  };
}
