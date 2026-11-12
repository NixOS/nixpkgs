{
  appimageTools,
  fetchurl,
  lib,
  makeWrapper,
}:

appimageTools.wrapType2 rec {
  pname = "lunarclient";
  version = "3.7.29";

  src = fetchurl {
    url = "https://launcher-releases.lunarclientprod.com/master/6e18b5a4f4ebbd4c7ecff572f1700cedce1f248bcb157adce5ec49be9e081a23/Lunar%20Client-3.7.29-ow.AppImage";
    hash = "sha512-dUXEKkyhJ39JgCxQwP4W5qQ608aIhVP+vOHOhxkdfff77ZCia9nczLoPXm2Ijpy9KI0V5/KKu1FMBp50z7Lt5g==";
  };

  nativeBuildInputs = [ makeWrapper ];

  extraInstallCommands =
    let
      contents = appimageTools.extract { inherit pname version src; };
    in
    ''
      wrapProgram $out/bin/lunarclient \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"
      install -Dm444 ${contents}/lunarclient.desktop -t $out/share/applications/
      install -Dm444 ${contents}/lunarclient.png -t $out/share/icons
      substituteInPlace $out/share/applications/lunarclient.desktop \
        --replace-fail 'Exec=AppRun --no-sandbox %U' 'Exec=lunarclient'
    '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Free Minecraft client with mods, cosmetics, and performance boost";
    homepage = "https://www.lunarclient.com/";
    license = lib.licenses.unfree;
    mainProgram = "lunarclient";
    maintainers = with lib.maintainers; [
      Technical27
      surfaceflinger
    ];
    platforms = [ "x86_64-linux" ];
  };
}
