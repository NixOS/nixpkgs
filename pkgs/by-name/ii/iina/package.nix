{ lib
, fetchurl
, stdenv
, undmg
, nix-update-script
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "iina";
  version = "1.3.5";

  src = fetchurl {
    url = "https://github.com/iina/iina/releases/download/v${finalAttrs.version}/IINA.v${finalAttrs.version}.dmg";
    hash = "sha256-O4uRmfQaGMKqizDlgk0MnazMHVkXaDLqZQ9TP8vcajg=";
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
    description = "The modern media player for macOS";
    homepage = "https://iina.io/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ arkivm donteatoreo stepbrobd ];
    mainProgram = "iina";
    platforms = platforms.darwin;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
})
