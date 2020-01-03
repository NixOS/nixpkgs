{ stdenv, fetchurl, cln, pkgconfig, readline, gmp, python }:

stdenv.mkDerivation rec {
  name = "ginac-1.7.8";

  src = fetchurl {
    url    = "${meta.homepage}/${name}.tar.bz2";
    sha256 = "0rvhdagmrs8ynnylwnxnmmfz1j9zk1g2rr7w6xczsbn7lqd511hc";
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
