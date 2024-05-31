{ lib, fetchurl, appimageTools, imagemagick }:

let
  pname = "chain-desktop-wallet";
  version = "0.1.1";

  src = fetchurl {
    url = "https://github.com/crypto-com/${pname}/releases/download/v${version}/${pname}-${version}-x86_64.AppImage";
    sha256 = "12076hf8dlz0hg1pb2ixwlslrh8gi6s1iawnvhnn6vz4jmjvq356";
  };

  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in appimageTools.wrapType2 rec {
  inherit pname version src;

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/${pname}.desktop $out/share/applications/${pname}.desktop
    ${imagemagick}/bin/convert ${appimageContents}/${pname}.png -resize 512x512 ${pname}_512.png
    install -m 444 -D ${pname}_512.png $out/share/icons/hicolor/512x512/apps/${pname}.png
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun --no-sandbox %U' 'Exec=${pname} %U'
  '';

  meta = with lib; {
    description = "Crypto.org Chain desktop wallet (Beta)";
    homepage = "https://github.com/crypto-com/chain-desktop-wallet";
    license = licenses.asl20;
    maintainers = with maintainers; [ th0rgal ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "chain-desktop-wallet";
  };
}
