{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation {
  pname = "ipafont";
  version = "003.03";

  src = fetchzip {
    url = "https://moji.or.jp/wp-content/ipafont/IPAfont/IPAfont00303.zip";
    hash = "sha256-EzUNKuDNHr0NIXiqX09w99wtz1r2pZurR/izdgzTcAs=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 *.ttf -t $out/share/fonts/opentype

    runHook postInstall
  '';

  meta = {
    description = "Japanese font package with Mincho and Gothic fonts";
    longDescription = ''
      IPAFont is a Japanese font developed by the Information-technology
      Promotion Agency of Japan. It provides both Mincho and Gothic fonts,
      suitable for both display and printing.
    '';
    homepage = "https://moji.or.jp/ipafont/";
    license = lib.licenses.ipa;
    maintainers = [ lib.maintainers.auntie ];
  };
}
