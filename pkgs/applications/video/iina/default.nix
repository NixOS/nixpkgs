{ lib
, fetchurl
, stdenv
, undmg
, nix-update-script
}:

stdenv.mkDerivation rec {
  pname = "iina";
  version = "1.3.3";

  src = fetchurl {
    url = "https://github.com/iina/iina/releases/download/v${version}/IINA.v${version}.dmg";
    hash = "sha256-Sz9sS+07t32+KcEr9tXQlZKEr7Ace1mjX9caOicIiZE=";
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
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ arkivm stepbrobd ];
  };
}
