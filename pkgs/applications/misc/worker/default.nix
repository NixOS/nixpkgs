{ stdenv, libX11, fetchurl }:

stdenv.mkDerivation rec {
  name = "worker-${version}";
  version = "3.15.2";

  src = fetchurl {
    url = "http://www.boomerangsworld.de/cms/worker/downloads/${name}.tar.gz";
    sha256 = "0km17ls51vp4nxlppf58vvxxymyx6w3xlzjc8wghxpjj098v4pp8";
  };

  buildInputs = [ libX11 ];

  meta = with stdenv.lib; {
    description = "A two-pane file manager with advanced file manipulation features";
    homepage = http://www.boomerangsworld.de/cms/worker/index.html;
    license =  licenses.gpl2;
    maintainers = [ maintainers.ndowens ];
  };
}
