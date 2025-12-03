{
  lib,
  appimageTools,
  fetchzip,
}:

let
  pname = "keet";
  version = "2.5.2";

  src = fetchzip {
    url = "https://static.keet.io/downloads/${version}/Keet-x64.tar.gz";
    hash = "sha256-wM5Z8zjha5uHmjBtjWRLQf8R/Xcz0O6myLrOMkeXBDM=";
  };

  appimageContents = appimageTools.extract {
    inherit pname version;
    src = "${src}/Keet.AppImage";
  };
in
appimageTools.wrapType2 {
  inherit pname version;

  src = "${src}/Keet.AppImage";

  extraPkgs =
    pkgs: with pkgs; [
      gtk4
      graphene
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
