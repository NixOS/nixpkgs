{ lib, stdenv, fetchurl, qmake, qtbase, qtwebkit, qtx11extras, lzo, libX11, wrapQtAppsHook }:

stdenv.mkDerivation rec {
  pname = "cb2bib";
  version = "2.0.0";
  src = fetchurl {
    url = "https://www.molspaces.com/dl/progs/${pname}-${version}.tar.gz";
    sha256 = "0gv7cnxi84lr6d5y71pd67h0ilmf5c88j1jxgyn9dvj19smrv99h";
  };
  buildInputs = [ qtbase qtwebkit qtx11extras lzo libX11 ];
  nativeBuildInputs = [ qmake wrapQtAppsHook ];

  configurePhase = ''
    runHook preConfigure
    ./configure --prefix $out --qmakepath $QMAKE
    runHook postConfigure
  '';

  meta = with lib; {
    description = "Rapidly extract unformatted, or unstandardized bibliographic references from email alerts, journal Web pages and PDF files";
    homepage = "http://www.molspaces.com/d_cb2bib-overview.php";
    maintainers = with maintainers; [ edwtjo ];
    license = licenses.gpl3;
  };

}
