{ lib
, stdenv
, fetchFromSourcehut
, redo-apenwarr
}:

stdenv.mkDerivation rec {
  pname = "slweb";
  version = "0.5.4";

  src = fetchFromSourcehut {
    owner = "~strahinja";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Wj9ZCs8nRBpIkX5jzTqBdo83zUBMamykk1vbBCIWyoQ=";
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
