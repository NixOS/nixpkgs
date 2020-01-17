{ stdenv, fetchurl, gfortran, arpack, spooles, openblas }:

stdenv.mkDerivation rec {
  pname = "calculix";
  version = "2.15";

  src = fetchurl {
    url = "http://www.dhondt.de/ccx_${version}.src.tar.bz2";
    sha256 = "0d4axfxgm3ag4p2vx9rjcky7c122k99a2nhv1jv53brm35rblzdw";
  };

  nativeBuildInputs = [ gfortran ];

  buildInputs = [ arpack spooles openblas ];

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

  meta = with stdenv.lib; {
    homepage = "http://www.calculix.de/";
    description = "Three-dimensional structural finite element program";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ gebner ];
    platforms = platforms.unix;
  };
}
