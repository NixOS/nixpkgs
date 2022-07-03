{ lib, fetchurl, appimageTools }:

let
  pname = "mobilecoin-wallet";
  version = "1.5.0";
  name = "${pname}-${version}";
  src = fetchurl {
    url = "https://github.com/mobilecoinofficial/desktop-wallet/releases/download/v${version}/MobileCoin-Wallet-${version}.AppImage";
    sha256 = "sha256-zSTtnKvgcDSiicEDuVK2LN2d8WHiGReYI3XLBmm3Fbo=";
  };
  appimageContents = appimageTools.extractType2 { inherit name src; };

in appimageTools.wrapType2 {
  inherit name src;

  extraPkgs = pkgs: (appimageTools.defaultFhsEnvArgs.multiPkgs pkgs) ++ [ pkgs.libsecret ];

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
    platforms = [ "x86_64-linux" ];
  };
}
