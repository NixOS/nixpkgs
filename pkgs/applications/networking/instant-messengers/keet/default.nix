{ lib, appimageTools, fetchzip }:

let
  pname = "keet";
  version = "2.2.0";

  src = fetchzip {
    url = "https://keet.io/downloads/${version}/Keet-x64.tar.gz";
    hash = "sha256-Sd2aCUvgxdbCb8MtWMcznX2efmL1h9wLT29GG7t3Gzc=";
  };

  appimageContents = appimageTools.extract {
    inherit pname version;
    src = "${src}/Keet.AppImage";
  };
in appimageTools.wrapType2 {
  inherit pname version;

  src = "${src}/Keet.AppImage";

  extraPkgs = pkgs: with pkgs; [
    gtk4
  ];

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/Keet.desktop -t $out/share/applications
    cp -r ${appimageContents}/*.png $out/share
  '';

  meta = with lib; {
    description = "Peer-to-Peer Chat";
    homepage = "https://keet.io";
    license = licenses.unfree;
    maintainers = with maintainers; [ extends ];
    platforms = [ "x86_64-linux" ];
  };
}
