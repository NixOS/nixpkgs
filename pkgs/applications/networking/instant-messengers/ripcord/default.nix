{ stdenv, fetchurl, appimageTools }:

let
  pname = "Ripcord";
  version = "0.4.18";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://cancel.fm/dl/${name}-x86_64.AppImage";
    sha256 = "19nv5pq8643l57hr5bdgn84rrw3ak2p9s16gr202nvi62flnl44p";
  };

  appimageContents = appimageTools.extractType2 {
    inherit name src;
  };
in appimageTools.wrapType2 rec {
  inherit name src;

  extraInstallCommands = ''
    mv $out/bin/${name} $out/bin/${pname}
    install -m 444 -D ${appimageContents}/Ripcord.desktop $out/share/applications/Ripcord.desktop
    install -m 444 -D ${appimageContents}/Ripcord_Icon.png $out/share/icons/hicolor/512x512/apps/Ripcord_Icon.png
  '';

  meta = with lib; {
    description = "A desktop chat client for Discord and Slack";
    homepage = "https://cancel.fm/ripcord/";
    license = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ MDeltaX ];
    platforms = [ "x86_64-linux" ];
  };
}
