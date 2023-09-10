{ lib
, stdenv
, fetchFromSourcehut
, redo-apenwarr
}:

stdenv.mkDerivation rec {
  pname = "slweb";
  version = "0.6.7";

  src = fetchFromSourcehut {
    owner = "~strahinja";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Y7w3yVqA8MNJJ3OcGaeziydZyzF0bap41Il6eE/Hu40=";
  };

  nativeBuildInputs = [ redo-apenwarr ];

  installPhase = ''
    runHook preInstall
    PREFIX=$out redo install
    runHook postInstall
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "A static website generator which aims at being simplistic";
    homepage = "https://strahinja.srht.site/slweb/";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
