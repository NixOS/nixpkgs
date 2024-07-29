{lib, stdenv, fetchurl, libjpeg, lcms2, gettext, libiconv }:

stdenv.mkDerivation rec {
  pname = "dcraw";
  version = "9.28.0";

  src = fetchurl {
    url = "https://www.dechifro.org/dcraw/archive/dcraw-${version}.tar.gz";
    sha256 = "1fdl3xa1fbm71xzc3760rsjkvf0x5jdjrvdzyg2l9ka24vdc7418";
  };

  nativeBuildInputs = lib.optional stdenv.hostPlatform.isDarwin libiconv;
  buildInputs = [ libjpeg lcms2 gettext ];

  # Jasper is disabled because the library is abandoned and has many
  # CVEs.
  patchPhase = ''
    substituteInPlace install \
      --replace 'prefix=/usr/local' 'prefix=$out' \
      --replace gcc '$CC' \
      --replace '-ljasper' '-DNO_JASPER=1'
  '';

  buildPhase = ''
    mkdir -p $out/bin
    sh -e install
  '';

  meta = {
    homepage = "https://www.dechifro.org/dcraw/";
    description = "Decoder for many camera raw picture formats";
    license = lib.licenses.free;
    platforms = lib.platforms.unix; # Once had cygwin problems
    maintainers = [ ];
    knownVulnerabilities = [
      "CVE-2018-19655"
      "CVE-2018-19565"
      "CVE-2018-19566"
      "CVE-2018-19567"
      "CVE-2018-19568"
    ];
  };
}
