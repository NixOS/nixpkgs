{ lib
, fetchurl
, stdenv
, undmg
, nix-update-script
}:

stdenv.mkDerivation rec {
  pname = "iina";
  version = "1.3.2";

  src = fetchurl {
    url = "https://github.com/iina/iina/releases/download/v${version}/IINA.v${version}.dmg";
    hash = "sha256-rF5yv2QHWVUUsyf/u78jWRn4C629GBJgB/i8YnaKHBk=";
  };

  nativeBuildInputs = [ undmg ];

  sourceRoot = "IINA.app";

  installPhase = ''
    mkdir -p "$out/Applications/IINA.app"
    cp -R . "$out/Applications/IINA.app"
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://iina.io/";
    description = "The modern media player for macOS";
    platforms = platforms.darwin;
    license = licenses.gpl3;
    maintainers = with maintainers; [ arkivm stepbrobd ];
  };
}
