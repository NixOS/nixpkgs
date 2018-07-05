{ wrapCommand, lib, fetchurl, jre, makeWrapper }:

let
  version = "2.7.1";
  jar = fetchurl {
    url = "mirror://sourceforge/project/circuit/2.7.x/${version}/logisim-generic-${version}.jar";
    sha256 = "1hkvc9zc7qmvjbl9579p84hw3n8wl3275246xlzj136i5b0phain";
  };
in wrapCommand "logisim" {
  inherit version;
  executable = "${jre}/bin/java";
  makeWrapperArgs = [ "--add-flags -jar" "--add-flags ${jar}" ];
  meta = with lib; {
    homepage = http://ozark.hendrix.edu/~burch/logisim;
    description = "Educational tool for designing and simulating digital logic circuits";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
  };
}
