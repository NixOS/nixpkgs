{ stdenv, fetchurl, which }:
let
  s = # Generated upstream information
  rec {
    baseName="eprover";
    version="1.9";
    name="${baseName}-${version}";
    hash="0vipapqjg0339lpc98vpvz58m6xkqrhgxylmp0hrnld4lrhmcdn4";
    url="http://wwwlehre.dhbw-stuttgart.de/~sschulz/WORK/E_DOWNLOAD/V_1.9/E.tgz";
    sha256="0vipapqjg0339lpc98vpvz58m6xkqrhgxylmp0hrnld4lrhmcdn4";
  };
in
stdenv.mkDerivation {
  inherit (s) name;

  src = fetchurl {
    name = "E-${s.version}.tar.gz";
    inherit (s) url sha256;
  };

  buildInputs = [ which ];

  preConfigure = ''
    sed -e 's@^EXECPATH\\s.*@EXECPATH = '\$out'/bin@' \
    -e 's/^CC *= gcc$//' \
    -i Makefile.vars
  '';

  buildPhase = "make install";

  installPhase = ''
    mkdir -p $out/bin
    make install
    echo eproof -xAuto --tstp-in --tstp-out '"$@"' > $out/bin/eproof-tptp
    chmod a+x $out/bin/eproof-tptp
  '';

  meta = {
    inherit (s) version;
    description = "Automated theorem prover for full first-order logic with equality";
    homepage = http://www.eprover.org/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.all;
  };
}
