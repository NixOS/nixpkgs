{ lib, stdenv, fetchurl, gfortran, arpack, spooles, blas, lapack }:

stdenv.mkDerivation rec {
  pname = "calculix";
  version = "2.17";

  src = fetchurl {
    url = "http://www.dhondt.de/ccx_${version}.src.tar.bz2";
    sha256 = "0l3fizxfdj2mpdp62wnk9v47q2yc3cy39fpsm629z7bjmba8lw6a";
  };

  nativeBuildInputs = [ gfortran ];

  buildInputs = [ arpack spooles blas lapack ];

  NIX_CFLAGS_COMPILE = "-I${spooles}/include/spooles";

  patches = [
    ./calculix.patch
  ];

  postPatch = ''
    cd ccx*/src
  '';

  installPhase = ''
    install -Dm0755 ccx_${version} $out/bin/ccx
  '';

  meta = with lib; {
    homepage = "http://www.calculix.de/";
    description = "Three-dimensional structural finite element program";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ gebner ];
    platforms = platforms.unix;
  };
}
