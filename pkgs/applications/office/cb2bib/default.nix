{ stdenv, fetchurl, qt5Full, lzo, libX11 }:

stdenv.mkDerivation rec {
  name = pname + "-" + version;
  pname = "cb2bib";
  version = "1.9.2";
  src = fetchurl {
    url = "http://www.molspaces.com/dl/progs/${name}.tar.gz";
    sha256 = "0yz79v023w1229wzck3gij0iqah1xg8rg4a352q8idvg7bdmyfin";
  };
  buildInputs = [ qt5Full lzo libX11 ];
  QTDIR=qt5Full;
  configurePhase =''
    ./configure --prefix $out
  '';

  meta = with stdenv.lib; {
    description = "Rapidly extract unformatted, or unstandardized bibliographic references from email alerts, journal Web pages and PDF files";
    homepage = http://www.molspaces.com/d_cb2bib-overview.php;
    maintainers = with maintainers; [ edwtjo ];
    license = licenses.gpl3;
  };

}