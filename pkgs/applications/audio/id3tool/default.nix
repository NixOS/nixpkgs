{ stdenv, lib, fetchurl }:

stdenv.mkDerivation {
  name = "id3tool-1.2a";
  src = fetchurl {
    url = "http://nekohako.xware.cx/id3tool/id3tool-1.2a.tar.gz";
    sha256 = "eQjWbFqr4qU66AGegjT0IxSF2Avksv5yydBAE8/xyuw=";
  };

  installPhase = ''
    mkdir -p $out/bin
    mv id3tool $out/bin
  '';

  meta = with lib; {
    description = "ID3 editing tool";
    homepage = "http://nekohako.xware.cx/id3tool/";
    license = licenses.bsd3;
    platforms = with platforms; linux ++ darwin;
  };
}
