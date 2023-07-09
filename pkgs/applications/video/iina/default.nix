{ lib
, fetchurl
, stdenv
, undmg
}:

stdenv.mkDerivation rec {
  pname = "iina";
  version = "1.3.2";

  src = fetchurl {
    url = "https://github.com/iina/iina/releases/download/v${version}/IINA.v${version}.dmg";
    hash = "sha256-yieAcMc3rqoURsAcc8iAbe1pohlAU3r76FsgUeiNTP8=";
  };

  nativeBuildInputs = [ undmg ];

  sourceRoot = "IINA.app";

  installPhase = ''
    mkdir -p "$out/Applications/IINA.app"
    cp -R . "$out/Applications/IINA.app"
  '';

  meta = with lib; {
    homepage = "https://iina.io/";
    description = "The modern media player for macOS";
    platforms = platforms.darwin;
    license = licenses.gpl3;
    maintainers = with maintainers; [ arkivm ];
  };
}
