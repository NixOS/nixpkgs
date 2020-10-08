{ stdenv, libX11, fetchurl }:

stdenv.mkDerivation rec {
  pname = "worker";
  version = "4.5.0";

  src = fetchurl {
    url = "http://www.boomerangsworld.de/cms/worker/downloads/${pname}-${version}.tar.gz";
    sha256 = "02xrdg1v784p4gfqjm1mlxqwi40qlbzhp68p5ksj96cjv6av5b5s";
  };

  buildInputs = [ libX11 ];

  meta = with stdenv.lib; {
    description = "A two-pane file manager with advanced file manipulation features";
    homepage = "http://www.boomerangsworld.de/cms/worker/index.html";
    license =  licenses.gpl2;
    maintainers = [];
  };
}
