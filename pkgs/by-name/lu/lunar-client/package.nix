{ appimageTools
, fetchurl
, lib
, makeWrapper
}:

appimageTools.wrapType2 rec {
  pname = "lunar-client";
  version = "3.2.4";

  src = fetchurl {
    url = "https://launcherupdates.lunarclientcdn.com/Lunar%20Client-${version}.AppImage";
    hash = "sha512-KaQvjtSzQzebzPrcFBntCqP6fRbenH9tQo4LYO1TwDoJ7pAeZ8D4kSMRaRfFV0CPZ/pDnKECYdKXAuaujOpw8g==";
  };

  extraInstallCommands =
    let contents = appimageTools.extract { inherit pname version src; };
    in ''
      mv $out/bin/{lunar-client-*,lunar-client}
      source "${makeWrapper}/nix-support/setup-hook"
      wrapProgram $out/bin/lunar-client \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"
      install -Dm444 ${contents}/launcher.desktop $out/share/applications/lunar-client.desktop
      install -Dm444 ${contents}/launcher.png $out/share/pixmaps/lunar-client.png
      substituteInPlace $out/share/applications/lunar-client.desktop \
        --replace 'Exec=AppRun --no-sandbox %U' 'Exec=lunar-client' \
        --replace 'Icon=launcher' 'Icon=lunar-client'
    '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Free Minecraft client with mods, cosmetics, and performance boost.";
    homepage = "https://www.lunarclient.com/";
    license = with licenses; [ unfree ];
    mainProgram = "lunar-client";
    maintainers = with maintainers; [ zyansheep Technical27 surfaceflinger ];
    platforms = [ "x86_64-linux" ];
  };
}
