{ fetchurl, stdenv, bash }:

stdenv.mkDerivation rec {
  version = "3.5-rc1";
  name = "nanoblogger-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/nanoblogger/${name}.tar.gz";
    sha256 = "09mv52a5f0h3das8x96irqyznm69arfskx472b7w3b9q4a2ipxbq";
  };

  buildInputs = [ ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r * $out
    cat > $out/bin/nb << EOF 
    #!${bash}/bin/bash
    $out/nb "\$@"
    EOF
    chmod 755 $out/bin/nb
  '';

  meta = {
    description = "Small weblog engine written in Bash for the command line";
    homepage = http://nanoblogger.sourceforge.net/;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.unix;
  };
}
