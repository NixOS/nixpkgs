{ appimageTools
, fetchurl
, lib
, makeWrapper
}:

let
  pname = "lunar-client";
  version = "3.1.0";

  src = fetchurl {
    url = "https://launcherupdates.lunarclientcdn.com/Lunar%20Client-${version}.AppImage";
    hash = "sha256-6OAGNkMyHOZI5wh92OtalnvUVFWNAS9PvkFS0e4YXhk=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 rec {
  inherit pname version src;

  extraInstallCommands = ''
    mv $out/bin/{${pname}-${version},${pname}}
    source "${makeWrapper}/nix-support/setup-hook"
    wrapProgram $out/bin/${pname} \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"
    install -Dm444 ${appimageContents}/launcher.desktop $out/share/applications/lunar-client.desktop
    install -Dm444 ${appimageContents}/launcher.png $out/share/pixmaps/lunar-client.png
    substituteInPlace $out/share/applications/lunar-client.desktop \
      --replace 'Exec=AppRun --no-sandbox %U' 'Exec=lunar-client' \
      --replace 'Icon=launcher' 'Icon=lunar-client'
  '';

  meta = with lib; {
    description = "Free Minecraft client with mods, cosmetics, and performance boost.";
    homepage = "https://www.lunarclient.com/";
    license = with licenses; [ unfree ];
    maintainers = with maintainers; [ zyansheep Technical27 surfaceflinger ];
    platforms = [ "x86_64-linux" ];
  };
}
