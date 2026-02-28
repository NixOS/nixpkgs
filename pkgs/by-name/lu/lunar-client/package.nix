{
  appimageTools,
  fetchurl,
  lib,
  makeWrapper,
}:

appimageTools.wrapType2 rec {
  pname = "lunarclient";
  version = "3.5.22";

  src = fetchurl {
    url = "https://launcherupdates.lunarclientcdn.com/Lunar%20Client-${version}-ow.AppImage";
    hash = "sha512-HdkkskXwwE6ee9/qeBcoOMaNLXUm6LdObF9HyM0JJC0IE0XZX90bU0c4QCQpF/1ZsS4Y4BW12+sqpEru4ABbsQ==";
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
      install -Dm444 ${contents}/lunarclient.png -t $out/share/pixmaps/
      substituteInPlace $out/share/applications/lunarclient.desktop \
        --replace-fail 'Exec=AppRun --no-sandbox %U' 'Exec=lunarclient' \
    '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Free Minecraft client with mods, cosmetics, and performance boost";
    homepage = "https://www.lunarclient.com/";
    license = with lib.licenses; [ unfree ];
    mainProgram = "lunarclient";
    maintainers = with lib.maintainers; [
      Technical27
      surfaceflinger
    ];
    platforms = [ "x86_64-linux" ];
  };
}
