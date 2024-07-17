{
  lib,
  fetchurl,
  appimageTools,
}:

let
  pname = "mobilecoin-wallet";
  version = "1.8.0";
  name = "${pname}-${version}";
  src = fetchurl {
    url = "https://github.com/mobilecoinofficial/desktop-wallet/releases/download/v${version}/MobileCoin.Wallet-${version}.AppImage";
    hash = "sha256-XGU/xxsMhOBAh+MeMtL2S707yH8HnoO9w5l7zqjO6rs=";
  };
  appimageContents = appimageTools.extractType2 { inherit name src; };

in
appimageTools.wrapType2 {
  inherit name src;

  extraPkgs = pkgs: [ pkgs.libsecret ];

  extraInstallCommands = ''
    mv $out/bin/${name} $out/bin/${pname}

    mkdir -p $out/share/${pname}
    cp -a ${appimageContents}/locales $out/share/${pname}
    cp -a ${appimageContents}/resources $out/share/${pname}
    cp -a ${appimageContents}/usr/share/icons $out/share/

    install -Dm 644 ${appimageContents}/${pname}.desktop -t $out/share/applications/

    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace "AppRun" "${pname}"
  '';

  meta = with lib; {
    description = "A user-friendly desktop wallet with support for transaction history, encrypted contact book, gift codes, and payments";
    homepage = "https://github.com/mobilecoinofficial/desktop-wallet";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ wolfangaukang ];
    mainProgram = "mobilecoin-wallet";
    platforms = [ "x86_64-linux" ];
  };
}
