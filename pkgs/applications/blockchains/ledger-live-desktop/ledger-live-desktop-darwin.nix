{
  stdenv,
  lib,
  fetchurl,
  _7zz,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "ledger-live-desktop";
  version = "2.89.1";

  src = fetchurl {
    url = "https://download.live.ledger.com/ledger-live-desktop-${finalAttrs.version}-mac.dmg";
    hash = "sha256-Q9cevGZy67YkCR6rkvqZiuPl/h+HyhXDyJnpn1OFfb0=";
  };
  sourceRoot = ".";

  nativeBuildInputs = [ _7zz ];

  dontConfigure = true;
  dontBuild = true;
  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r "Ledger Live.app" $out/Applications

    runHook postInstall
  '';

  meta = with lib; {
    description = "App for Ledger hardware wallets";
    homepage = "https://www.ledger.com/ledger-live/";
    license = licenses.mit;
    maintainers = with maintainers; [
      andresilva
      thedavidmeister
      nyanloutre
      RaghavSood
      th0rgal
    ];
    platforms = platforms.darwin;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
})
