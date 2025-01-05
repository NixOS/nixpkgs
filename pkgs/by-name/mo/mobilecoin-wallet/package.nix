{
  lib,
  fetchurl,
  appimageTools,
}:

let
  pname = "mobilecoin-wallet";
  version = "1.9.1";
  src = fetchurl {
    url = "https://github.com/mobilecoinofficial/desktop-wallet/releases/download/v${version}/MobileCoin.Wallet-${version}.AppImage";
    hash = "sha256-UCBQRcGFHMQlLGvChrrMmM0MYv7AZtlkngFK4ptIPU0=";
  };
  appimageContents = appimageTools.extractType2 { inherit pname version src; };

in
appimageTools.wrapType2 {
  inherit pname version src;

  extraPkgs = pkgs: [ pkgs.libsecret ];

  extraInstallCommands = ''
    mkdir -p $out/share/${pname}
    cp -a ${appimageContents}/locales $out/share/${pname}
    cp -a ${appimageContents}/resources $out/share/${pname}
    cp -a ${appimageContents}/usr/share/icons $out/share/

    install -Dm 644 ${appimageContents}/${pname}.desktop -t $out/share/applications/

    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace "AppRun" "${pname}"
  '';

  meta = with lib; {
    description = "User-friendly desktop wallet with support for transaction history, encrypted contact book, gift codes, and payments";
    homepage = "https://github.com/mobilecoinofficial/desktop-wallet";
    license = licenses.gpl3Only;
    maintainers = [ ];
    mainProgram = "mobilecoin-wallet";
    platforms = [ "x86_64-linux" ];
  };
}
