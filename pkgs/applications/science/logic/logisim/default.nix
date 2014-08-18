{ stdenv, fetchurl, jre }:

let version = "2.7.1"; in

stdenv.mkDerivation {
  name = "logisim-${version}";
  
  src = fetchurl {
    url = "mirror://sourceforge/project/circuit/2.7.x/${version}/logisim-generic-${version}.jar";
    sha256 = "1hkvc9zc7qmvjbl9579p84hw3n8wl3275246xlzj136i5b0phain";
  };
  
  phases = [ "installPhase" ];
  
  installPhase = ''
    mkdir -pv $out/bin
    cp -v $src $out/logisim.jar
    
    cat > $out/bin/logisim << EOF
    #!${stdenv.shell}
    ${jre}/bin/java -jar $out/logisim.jar
    EOF
    
    chmod +x $out/bin/logisim
  '';
  
  meta = {
    homepage = "http://ozark.hendrix.edu/~burch/logisim";
    description = "Educational tool for designing and simulating digital logic circuits";
    license = "GPLv2+";
  };
}
