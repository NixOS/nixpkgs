{ lib, fetchurl, appimageTools }:

appimageTools.wrapType2 rec {
  pname = "zecwallet-lite";
  version = "1.8.8";

  src = fetchurl {
    url = "https://github.com/adityapk00/zecwallet-lite/releases/download/v${version}/Zecwallet.Lite-${version}.AppImage";
    hash = "sha256-6jppP3V7R8tCR5Wv5UWfbWKkAdsgrCjSiO/bbpLNcw4=";
  };

  extraInstallCommands =
    let contents = appimageTools.extract { inherit pname version src; };
    in ''
      install -m 444 -D ${contents}/zecwallet-lite.desktop -t $out/share/applications
      substituteInPlace $out/share/applications/zecwallet-lite.desktop \
        --replace 'Exec=AppRun' "Exec=$out/bin/zecwallet-lite"
      cp -r ${contents}/usr/share/icons $out/share
    '';

  meta = with lib; {
    description = "A fully featured shielded wallet for Zcash";
    homepage = "https://www.zecwallet.co/";
    license = licenses.mit;
    maintainers = with maintainers; [ colinsane ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "zecwallet-lite";
  };
}
