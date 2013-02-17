{ stdenv, fetchurl, cln, pkgconfig, readline }:

stdenv.mkDerivation rec {
  name = "ginac-1.6.2";

  src = fetchurl {
    url = "${meta.homepage}/${name}.tar.bz2";
    sha256 = "1pivcqqaf142l6vrj2azq6dxrcyzhag4za2dwicb4gsb09ax4d0g";
  };

  propagatedBuildInputs = [ cln ];
  buildInputs = [ readline ];

  nativeBuildInputs = [ pkgconfig ];

  configureFlags = "--disable-rpath";

  meta = {
    description = "GiNaC is Not a CAS";
    homepage = http://www.ginac.de/;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
