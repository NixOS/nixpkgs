{ appimageTools
, fetchurl
, lib
, makeWrapper
}:

appimageTools.wrapType2 rec {
  pname = "lunarclient";
  version = "3.2.17";

  src = fetchurl {
    url = "https://launcherupdates.lunarclientcdn.com/Lunar%20Client-${version}.AppImage";
    hash = "sha512-hzW7khHfWEYPtzMmedy/dXqKh7LPniqI7/0F1FtBtrlDnEIEQUq/7VUcygsVTBI6kuj8vTG5+PYcLez+cYAjqg==";
  };

  extraInstallCommands =
    let contents = appimageTools.extract { inherit pname version src; };
    in ''
      source "${makeWrapper}/nix-support/setup-hook"
      wrapProgram $out/bin/lunarclient \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"
      install -Dm444 ${contents}/lunarclient.desktop -t $out/share/applications/
      install -Dm444 ${contents}/lunarclient.png -t $out/share/pixmaps/
      substituteInPlace $out/share/applications/lunarclient.desktop \
        --replace-fail 'Exec=AppRun --no-sandbox %U' 'Exec=lunarclient' \
    '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Free Minecraft client with mods, cosmetics, and performance boost";
    homepage = "https://www.lunarclient.com/";
    license = with licenses; [ unfree ];
    mainProgram = "lunarclient";
    maintainers = with maintainers; [ Technical27 surfaceflinger ];
    platforms = [ "x86_64-linux" ];
  };
}
