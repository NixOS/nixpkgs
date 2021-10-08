{ lib, fetchurl, appimageTools }:

let
  pname = "tutanota-desktop";
  version = "3.88.4";
  name = "tutanota-desktop-${version}";
  src = fetchurl {
    url = "https://mail.tutanota.com/desktop/tutanota-desktop-linux.AppImage";
    name = "tutanota-desktop-${version}.AppImage";
    sha256 = "sha256-MwvH6SGZwcvxAr5olklqKTF2p2pv8+F5qwpmwN3uZkc=";
  };
  appimageContents = appimageTools.extractType2 { inherit name src; };

in appimageTools.wrapType2 {
  inherit name src;

  extraPkgs = pkgs: (appimageTools.defaultFhsEnvArgs.multiPkgs pkgs) ++ [ pkgs.libsecret ];

  extraInstallCommands = ''
    mv $out/bin/${name} $out/bin/${pname}

    install -m 444 -D ${appimageContents}/tutanota-desktop.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/tutanota-desktop.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  meta = with lib; {
    description = "Tutanota official desktop client";
    homepage = "https://tutanota.com/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ wolfangaukang ];
    platforms = [ "x86_64-linux" ];
  };
}
