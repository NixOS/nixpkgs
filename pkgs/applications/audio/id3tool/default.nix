{ lib, stdenv, fetchurl }:

stdenv.mkDerivation {
  pname = "id3tool";
  version = "1.2a";

  src = fetchurl {
    url = "http://nekohako.xware.cx/id3tool/id3tool-1.2a.tar.gz";
    sha256 = "eQjWbFqr4qU66AGegjT0IxSF2Avksv5yydBAE8/xyuw=";
  };

  installPhase = ''
    runHook preInstall

    install -D id3tool "$out/bin/id3tool"

    runHook postInstall
  '';

  meta = with lib; {
    description = "ID3 editing tool";
    homepage = "http://nekohako.xware.cx/id3tool/";
    license = licenses.bsd3;
    maintainers = with maintainers; [  ];
    platforms = with platforms; linux ++ darwin;
  };
}
