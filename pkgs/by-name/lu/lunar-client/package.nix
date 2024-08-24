{ appimageTools
, fetchurl
, lib
, makeWrapper
}:

appimageTools.wrapType2 rec {
  pname = "lunarclient";
  version = "3.2.16";

  src = fetchurl {
    url = "https://launcherupdates.lunarclientcdn.com/Lunar%20Client-${version}.AppImage";
    hash = "sha512-p+a7zirfM4rR4CPsXGa6jPhh0sFvoQN1O/roSZYA+qbhhtRS0MgnvuSN6EKdH37M5cF2KoNOqfapWE3PWWK19A==";
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
