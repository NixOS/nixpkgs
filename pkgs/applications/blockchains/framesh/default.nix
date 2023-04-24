{ lib, fetchurl, appimageTools }:

let
  pname = "framesh";
  version = "0.6.2";
  src = fetchurl {
    url = "https://github.com/floating/frame/releases/download/v${version}/Frame-${version}.AppImage";
    sha256 = "sha256-nN5+6SwfHcwhePlbsXjT3qNd/d6Xqnd85NVC8vw3ehk=";
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    ln -s $out/bin/${pname}-${version} $out/bin/${pname}
    install -m 444 -D ${appimageContents}/frame.desktop $out/share/applications/frame.desktop
    install -m 444 -D ${appimageContents}/frame.png \
      $out/share/icons/hicolor/512x512/apps/frame.png
    substituteInPlace $out/share/applications/frame.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = {
    description = "Native web3 interface that lets you sign data, securely manage accounts and transparently interact with dapps via web3 protocols like Ethereum and IPFS";
    homepage = "https://frame.sh/";
    downloadPage = "https://github.com/floating/frame/releases";
    license = lib.licenses.gpl3Only;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ nook ];
  };
}
