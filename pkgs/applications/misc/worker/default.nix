{ stdenv, libX11, fetchurl }:

stdenv.mkDerivation rec {
  name = "worker-${version}";
  version = "4.0.0";

  src = fetchurl {
    url = "http://www.boomerangsworld.de/cms/worker/downloads/${name}.tar.gz";
    sha256 = "0cs1sq7zpp787r1irhqk5pmxa26rjz55mbgda4823z9zkzwfxy19";
  };

  buildInputs = [ libX11 ];

  meta = with stdenv.lib; {
    description = "A two-pane file manager with advanced file manipulation features";
    homepage = http://www.boomerangsworld.de/cms/worker/index.html;
    license =  licenses.gpl2;
    maintainers = [ maintainers.ndowens ];
  };
}
