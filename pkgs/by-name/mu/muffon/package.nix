{ lib
, fetchurl
, appimageTools
, makeWrapper
}:

let
  pname = "muffon";
  version = "2.0.2";
  src = fetchurl {
    url = "https://github.com/staniel359/${pname}/releases/download/v${version}/${pname}-${version}-linux-x86_64.AppImage";
    hash = "sha256-bJfnYX5ZCAJNSGP4WJcDpVKX7yAqFYC7sqDIGQWwkTM=";
  };
  appimageContents = appimageTools.extractType2 { inherit pname src version; };

in appimageTools.wrapType2 {
  inherit pname src version;

  extraInstallCommands = ''
    mv $out/bin/${pname}-${version} $out/bin/${pname}
    source "${makeWrapper}/nix-support/setup-hook"
    wrapProgram $out/bin/${pname} \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"
    install -m 444 -D ${appimageContents}/muffon.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/muffon.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
    install -m 444 -D ${appimageContents}/muffon.png \
      $out/share/icons/hicolor/512x512/apps/muffon.png
  '';

  meta = with lib; {
    description = "Advanced multi-source music streaming client";
    homepage = "https://muffon.netlify.app/";
    changelog = "https://github.com/staniel359/muffon/releases/tag/v${version}";
    license = licenses.agpl3;
    maintainers = with maintainers; [ octodi ];
    mainProgram = "muffon";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
  };
}
