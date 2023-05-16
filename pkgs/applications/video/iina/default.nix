{ lib
, fetchurl
, stdenv
, undmg
<<<<<<< HEAD
, nix-update-script
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenv.mkDerivation rec {
  pname = "iina";
<<<<<<< HEAD
  version = "1.3.3";

  src = fetchurl {
    url = "https://github.com/iina/iina/releases/download/v${version}/IINA.v${version}.dmg";
    hash = "sha256-Sz9sS+07t32+KcEr9tXQlZKEr7Ace1mjX9caOicIiZE=";
=======
  version = "1.3.1";

  src = fetchurl {
    url = "https://github.com/iina/iina/releases/download/v${version}/IINA.v${version}.dmg";
    sha256 = "sha256-xkZkKiiEywUWkiFw4PbUmQsStB1iRLCNU/MY27lRjC8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ undmg ];

  sourceRoot = "IINA.app";

  installPhase = ''
    mkdir -p "$out/Applications/IINA.app"
    cp -R . "$out/Applications/IINA.app"
  '';

<<<<<<< HEAD
  passthru.updateScript = nix-update-script { };

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    homepage = "https://iina.io/";
    description = "The modern media player for macOS";
    platforms = platforms.darwin;
    license = licenses.gpl3;
<<<<<<< HEAD
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ arkivm stepbrobd ];
=======
    maintainers = with maintainers; [ arkivm ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
