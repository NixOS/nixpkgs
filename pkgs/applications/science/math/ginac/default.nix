{ lib, stdenv, fetchurl, cln, pkg-config, readline, gmp, python }:

stdenv.mkDerivation rec {
  name = "ginac-1.8.0";

  src = fetchurl {
    url    = "${meta.homepage}/${name}.tar.bz2";
    sha256 = "0l9byzfxq3f9az5pcdldnl95ws8mpirkqky46f973mvxi5541d24";
  };

  propagatedBuildInputs = [ cln ];

  buildInputs = [ readline ] ++ lib.optional stdenv.isDarwin gmp;

  nativeBuildInputs = [ pkg-config python ];

  preConfigure = "patchShebangs ginsh";

  configureFlags = [ "--disable-rpath" ];

  meta = with lib; {
    description = "GiNaC is Not a CAS";
    homepage    = "http://www.ginac.de/";
    maintainers = with maintainers; [ lovek323 ];
    license = licenses.gpl2;
    platforms   = platforms.all;
  };
}
