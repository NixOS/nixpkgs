{ lib
, stdenv
, fetchFromSourcehut
, redo-apenwarr
}:

stdenv.mkDerivation rec {
  pname = "slweb";
<<<<<<< HEAD
  version = "0.6.7";
=======
  version = "0.5.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromSourcehut {
    owner = "~strahinja";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-Y7w3yVqA8MNJJ3OcGaeziydZyzF0bap41Il6eE/Hu40=";
=======
    sha256 = "sha256-Wj9ZCs8nRBpIkX5jzTqBdo83zUBMamykk1vbBCIWyoQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
