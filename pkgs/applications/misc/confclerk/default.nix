{ stdenv, fetchurl, qt4, qmake4Hook }:

let version = "0.6.1"; in
stdenv.mkDerivation {
  name = "confclerk-${version}";

  src = fetchurl {
    url = "http://www.toastfreeware.priv.at/tarballs/confclerk/confclerk-${version}.tar.gz";
    sha256 = "1wprndshmc7k1919n7k93c4ha2jp171q31gx7xsbzx7g4sw6432g";
  };

  buildInputs = [ qt4 ];

  nativeBuildInputs = [ qmake4Hook ];

  installPhase = ''
    mkdir -p $out/bin
    cp src/bin/confclerk $out/bin
  '';

  meta = {
    description = "Offline conference schedule viewer";
    homepage = http://www.toastfreeware.priv.at/confclerk;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ ehmry ];
    inherit (qt4.meta) platforms;
  };
}
