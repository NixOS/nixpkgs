{ lib
, fetchurl
, stdenv
, undmg
, nix-update-script
}:

stdenv.mkDerivation rec {
  pname = "iina";
  version = "1.3.4";

  src = fetchurl {
    url = "https://github.com/iina/iina/releases/download/v${version}/IINA.v${version}.dmg";
    hash = "sha256-feUPWtSi/Vsnv1mjGyBgB0wFMxx6r6UzrUratlAo14w=";
  };

  nativeBuildInputs = [ undmg ];

  sourceRoot = "IINA.app";

  installPhase = ''
    mkdir -p $out/{bin,Applications/IINA.app}
    cp -R . "$out/Applications/IINA.app"
    ln -s "$out/Applications/IINA.app/Contents/MacOS/iina-cli" "$out/bin/iina"
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://iina.io/";
    description = "The modern media player for macOS";
    platforms = platforms.darwin;
    license = licenses.gpl3;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    mainProgram = "iina";
    maintainers = with maintainers; [ arkivm stepbrobd ];
  };
}
