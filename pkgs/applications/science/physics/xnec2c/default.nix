{ lib
, stdenv
, fetchurl
, autoreconfHook
, wrapGAppsHook3
, pkg-config
, which
, gtk3
, blas
, lapack
}:

assert (!blas.isILP64) && (!lapack.isILP64);

stdenv.mkDerivation rec {
  pname = "xnec2c";
  version = "4.4.16";

  src = fetchurl {
    url = "https://www.xnec2c.org/releases/${pname}-v${version}.tar.gz";
    hash = "sha256-XiZi8pfmfHjGpePkRy/pF1TA+5RdxX4AGuKzG5Wqrmk=";
  };

  nativeBuildInputs = [
    autoreconfHook
    wrapGAppsHook3
    pkg-config
    which
  ];
  buildInputs = [ gtk3 blas lapack ];

  meta = with lib; {
    homepage = "https://www.xnec2c.org/";
    description = "Graphical antenna simulation";
    mainProgram = "xnec2c";
    license = licenses.gpl3;
    maintainers = with maintainers; [ mvs ];
    platforms = platforms.unix;

    # Darwin support likely to be fixed upstream in the next release
    broken = stdenv.isDarwin;
  };
}
