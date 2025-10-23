{
  lib,
  fetchurl,
  appimageTools,
  makeWrapper,
}:

let
  pname = "plexamp";
  version = "4.13.0";

  src = fetchurl {
    url = "https://plexamp.plex.tv/plexamp.plex.tv/desktop/Plexamp-${version}.AppImage";
    name = "${pname}-${version}.AppImage";
    hash = "sha512-3Blgl3t21hH6lgDe5u3vy3I/3k9b4VM1CvoZg2oashkGXSDwV8q7MATN9YjsBgWysNXwdm7nQ/yrFQ7DiRfdYg==";
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/plexamp.desktop $out/share/applications/plexamp.desktop
    install -m 444 -D ${appimageContents}/plexamp.svg \
      $out/share/icons/hicolor/scalable/apps/plexamp.svg
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
    source "${makeWrapper}/nix-support/setup-hook"
    wrapProgram "$out/bin/plexamp" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"
  '';

  passthru.updateScript = ./update-plexamp.sh;

  meta = with lib; {
    description = "Beautiful Plex music player for audiophiles, curators, and hipsters";
    homepage = "https://plexamp.com/";
    changelog = "https://forums.plex.tv/t/plexamp-release-notes/221280/82";
    license = licenses.unfree;
    maintainers = with maintainers; [
      killercup
      redhawk
      synthetica
    ];
    platforms = [ "x86_64-linux" ];
  };
}
