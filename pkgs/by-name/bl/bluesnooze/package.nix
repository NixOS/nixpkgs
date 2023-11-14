{ lib
, stdenvNoCC
, fetchzip
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "bluesnooze";
  version = "1.2";

  src = fetchzip {
    url = "https://github.com/odlp/${finalAttrs.pname}/releases/download/v${finalAttrs.version}/Bluesnooze.zip";
    hash = "sha256-ROGYzErQH2eRli2ccxv/859wMBd4WncEonY+2QR/G7w=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r $src/Bluesnooze.app $out/Applications/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Bluesnooze prevents your sleeping Mac from connecting to Bluetooth accessories. Sleeping Mac = Bluetooth off";
    homepage = "https://github.com/odlp/bluesnooze";
    license = licenses.mit;
    maintainers = [ maintainers.frogamic ];
    platforms = platforms.darwin;
  };
})
