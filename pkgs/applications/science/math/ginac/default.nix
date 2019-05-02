{ stdenv, fetchurl, cln, pkgconfig, readline, gmp, python }:

stdenv.mkDerivation rec {
  name = "ginac-1.7.6";

  src = fetchurl {
    url    = "${meta.homepage}/${name}.tar.bz2";
    sha256 = "03cq93qjfgxgr7zxadrjfbn43lk5f0x2lmd90ggx10p6jq47157v";
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
