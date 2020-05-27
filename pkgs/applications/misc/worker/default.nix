{ stdenv, libX11, fetchurl }:

stdenv.mkDerivation rec {
  pname = "worker";
  version = "4.4.0";

  src = fetchurl {
    url = "http://www.boomerangsworld.de/cms/worker/downloads/${pname}-${version}.tar.gz";
    sha256 = "1k2svpzq01n1h9365nhi7r2k7dmsviczxi9m6fb80ccccdz7i530";
  };

  buildInputs = [ libX11 ];

  meta = with stdenv.lib; {
    description = "A two-pane file manager with advanced file manipulation features";
    homepage = "http://www.boomerangsworld.de/cms/worker/index.html";
    license =  licenses.gpl2;
    maintainers = [];
  };
}
