args: with args; stdenv.mkDerivation {
  name = "i810switch-0.6.5";

  phases = "unpackPhase installPhase";

  installPhase = "
    sed -i -e 's+/usr++' Makefile
    sed -i -e 's+^\\(.*putenv(\"PATH=\\).*$+\\1${pciutils}/sbin\");+' i810switch.c
    make clean
    make install DESTDIR=\${out}
  ";

  inherit pciutils;

  src = fetchurl {
    url = http://www16.plala.or.jp/mano-a-mano/i810switch/i810switch-0.6.5.tar.gz;
    sha256 = "d714840e3b14e1fa9c432c4be0044b7c008d904dece0d611554655b979cad4c3";
  };

  meta = {
    description = "i810switch is a utility for switching the LCD and external VGA display.";
    homepage = "http://www16.plala.or.jp/mano-a-mano/i810switch.html";
    license = "GPL2";
  };
}
