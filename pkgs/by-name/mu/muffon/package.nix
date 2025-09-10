{
  lib,
  fetchurl,
  appimageTools,
  makeWrapper,
}:

let
  pname = "muffon";
  version = "2.3.0";
  src = fetchurl {
    url = "https://github.com/staniel359/muffon/releases/download/v${version}/muffon-${version}-linux-x86_64.AppImage";
    hash = "sha256-C9oaRXS4w89i4tq/hWh5n5uHUETzaoEid49OII/+5dg=";
  };
  appimageContents = appimageTools.extractType2 { inherit pname src version; };
in
appimageTools.wrapType2 {
  inherit pname src version;

  nativeBuildInputs = [ makeWrapper ];

  extraInstallCommands = ''
    wrapProgram $out/bin/muffon \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"
    install -m 444 -D ${appimageContents}/muffon.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/muffon.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=muffon'
    install -m 444 -D ${appimageContents}/muffon.png \
      $out/share/icons/hicolor/512x512/apps/muffon.png
  '';

  meta = {
    description = "Advanced multi-source music streaming client";
    homepage = "https://muffon.netlify.app/";
    changelog = "https://github.com/staniel359/muffon/releases/tag/v${version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ octodi ];
    mainProgram = "muffon";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
  };
}
