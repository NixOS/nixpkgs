{ stdenv, fetchurl, qt4, qmake4Hook }:

let version = "0.6.4"; in
stdenv.mkDerivation {
  name = "confclerk-${version}";

  src = fetchurl {
    url = "https://www.toastfreeware.priv.at/tarballs/confclerk/confclerk-${version}.tar.gz";
    sha256 = "10rhg44px4nvbkd3p341cmp2ds43jn8r4rvgladda9v8zmsgr2b3";
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
    platforms = stdenv.lib.platforms.linux;
  };
}
