{ stdenv, libX11, fetchurl }:

stdenv.mkDerivation rec {
  pname = "worker";
  version = "4.2.0";

  src = fetchurl {
    url = "http://www.boomerangsworld.de/cms/worker/downloads/${pname}-${version}.tar.gz";
    sha256 = "17b845x09q0cfk12hd3f7y08diqrflrr2aj2nwf4szy4f52jk5gz";
  };

  buildInputs = [ libX11 ];

  meta = with stdenv.lib; {
    description = "A two-pane file manager with advanced file manipulation features";
    homepage = http://www.boomerangsworld.de/cms/worker/index.html;
    license =  licenses.gpl2;
    maintainers = [];
  };
}
