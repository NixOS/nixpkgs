{ stdenv, libX11, fetchurl }:

stdenv.mkDerivation rec {
  pname = "worker";
  version = "4.0.1";

  src = fetchurl {
    url = "http://www.boomerangsworld.de/cms/worker/downloads/${pname}-${version}.tar.gz";
    sha256 = "1mwkyak68bsxgff399xmr7bb3hxl0r976b90zi7jrzznwlvxx7vh";
  };

  buildInputs = [ libX11 ];

  meta = with stdenv.lib; {
    description = "A two-pane file manager with advanced file manipulation features";
    homepage = http://www.boomerangsworld.de/cms/worker/index.html;
    license =  licenses.gpl2;
    maintainers = [ maintainers.ndowens ];
  };
}
