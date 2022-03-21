{ lib
, fetchurl
, stdenv
, undmg
}:

stdenv.mkDerivation rec {
  pname = "iina";
  version = "1.2.0";

  src = fetchurl {
    url = "https://github.com/iina/iina/releases/download/v${version}/IINA.v${version}.dmg";
    sha256 = "sha256-kbh+gAVfCXoct6jJGXnetTAzFfIGdVLL5zh/SL/EJzY=";
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
