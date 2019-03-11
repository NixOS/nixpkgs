{ stdenv, libX11, fetchurl }:

stdenv.mkDerivation rec {
  name = "worker-${version}";
  version = "3.15.3";

  src = fetchurl {
    url = "http://www.boomerangsworld.de/cms/worker/downloads/${name}.tar.gz";
    sha256 = "03dv50h68grscxiaxslzv486v1bfi8y81vrjr2gs39svw7bwz5d4";
  };

  buildInputs = [ libX11 ];

  meta = with stdenv.lib; {
    description = "A two-pane file manager with advanced file manipulation features";
    homepage = http://www.boomerangsworld.de/cms/worker/index.html;
    license =  licenses.gpl2;
    maintainers = [ maintainers.ndowens ];
  };
}
