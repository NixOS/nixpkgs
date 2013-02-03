{ stdenv, fetchurl, cmake, x11, libX11, libXi, libXtst }:

stdenv.mkDerivation rec {
  name = "synergy-1.4.10";

  src = fetchurl {
  	url = "http://synergy.googlecode.com/files/${name}-Source.tar.gz";
  	sha256 = "1ghgf96gbk4sdw8sqlc3pjschkmmqybihi12mg6hi26gnk7a5m86";
  };

  buildInputs = [ cmake x11 libX11 libXi libXtst ];
  
  # At this moment make install doesn't work for synergy
  # http://synergy-foss.org/spit/issues/details/3317/

  
  installPhase = ''
    ensureDir $out/bin
    cp ../bin/synergyc $out/bin
    cp ../bin/synergys $out/bin
    cp ../bin/synergyd $out/bin
  '';

  meta = { 
    description = "Tool to share the mouse keyboard and the clipboard between computers";
    homepage = http://synergy-foss.org;
    license = "GPL";
  };
}
