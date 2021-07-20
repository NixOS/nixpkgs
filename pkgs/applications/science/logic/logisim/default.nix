{ lib, stdenv, fetchurl, jre, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "logisim";
  version = "2.7.1";

  src = fetchurl {
    url = "mirror://sourceforge/project/circuit/${lib.versions.majorMinor version}.x/${version}/logisim-generic-${version}.jar";
    sha256 = "1hkvc9zc7qmvjbl9579p84hw3n8wl3275246xlzj136i5b0phain";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    makeWrapper ${jre}/bin/java $out/bin/logisim --add-flags "-jar $src"
  '';

  meta = with lib; {
    homepage = "http://ozark.hendrix.edu/~burch/logisim";
    description = "Educational tool for designing and simulating digital logic circuits";
    maintainers = with maintainers; [ ];
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
  };
}
