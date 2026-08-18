{
  lib,
  appimageTools,
  fetchurl,
  makeWrapper,
}:

let
  pname = "spinshare";
  version = "3.32.1";

  src = fetchurl {
    url = "https://github.com/SpinShare/client-next/releases/download/v${version}/SpinShare-${version}-x64.AppImage";
    hash = "sha256-LJjMel0CsvBf+IgyH7DArj/1oWk/dKpPa1aIED69yeE=";
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;
  };
in
(appimageTools.wrapType2 {
  inherit pname version src;

  nativeBuildInputs = [ makeWrapper ];

  extraInstallCommands = ''
    install -Dm444 ${appimageContents}/SpinShare.desktop \
      $out/share/applications/spinshare.desktop
    substituteInPlace $out/share/applications/spinshare.desktop \
      --replace-fail 'Exec=spinshare-client-next' 'Exec=spinshare'
    install -Dm444 ${appimageContents}/usr/share/icons/hicolor/1024x1024/apps/SpinShare.png \
      $out/share/icons/hicolor/1024x1024/apps/SpinShare.png

    wrapProgram $out/bin/spinshare \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"
  '';

  meta = {
    description = "Cross-platform custom chart client for Spin Rhythm XD";
    homepage = "https://spinsha.re/client-next";
    downloadPage = "https://github.com/SpinShare/client-next/releases";
    changelog = "https://github.com/SpinShare/client-next/releases/tag/v${version}";
    license = lib.licenses.agpl3Only;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = with lib.maintainers; [ different-name ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "spinshare";
  };
}).overrideAttrs
  {
    strictDeps = true;
  }
