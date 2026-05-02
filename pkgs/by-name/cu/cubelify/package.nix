{
  appimageTools,
  fetchurl,
  lib,
  makeWrapper,
}:
appimageTools.wrapType2 rec {
  pname = "cubelify";
  version = "1.25.11";

  src = fetchurl {
    url = "https://storage.cubelify.com/overlay/v1/Cubelify%20Overlay-${version}.AppImage";
    hash = "sha512-iWOkFTH5iPw3gzirWph14f8/M0cLQgsUyGX5Xnestc1oqcrKOJgdVb65RBWgCQBywhMkEXC0h1wzaZiBaKYuAQ==";
  };

  nativeBuildInputs = [ makeWrapper ];

  extraInstallCommands =
    let
      contents = appimageTools.extract { inherit pname version src; };
    in
    ''
      wrapProgram $out/bin/cubelify \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"
      install -Dm444 ${contents}/cubelify-overlay.desktop -t $out/share/applications/
      install -Dm444 ${contents}/cubelify-overlay.png -t $out/share/pixmaps/
      substituteInPlace $out/share/applications/cubelify-overlay.desktop \
        --replace-fail 'Exec=AppRun --no-sandbox %U' 'Exec=cubelify'
    '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Powerful and feature-rich Hypixel anti-sniping stats overlay";
    homepage = "https://cubelify.com/";
    license = with lib.licenses; [ unfree ];
    mainProgram = "cubelify";
    maintainers = with lib.maintainers; [ yunfachi ];
    platforms = [ "x86_64-linux" ];
  };
}
