{ stdenv, fetchurl, jre, makeWrapper }:

let version = "2.7.1"; in

stdenv.mkDerivation {
  name = "logisim-${version}";
  
  src = fetchurl {
    url = "mirror://sourceforge/project/circuit/2.7.x/${version}/logisim-generic-${version}.jar";
    sha256 = "1hkvc9zc7qmvjbl9579p84hw3n8wl3275246xlzj136i5b0phain";
  };
  
  phases = [ "installPhase" ];

  nativeBuildInputs = [makeWrapper];

  installPhase = ''
    mkdir -pv $out/bin
    makeWrapper ${jre}/bin/java $out/bin/logisim --add-flags "-jar $src"
  '';
  
  meta = {
    homepage = "http://ozark.hendrix.edu/~burch/logisim";
    description = "Educational tool for designing and simulating digital logic circuits";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.unix;
  };
}
