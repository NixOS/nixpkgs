{
  lib,
  fetchurl,
  appimageTools,
  makeWrapper,
}:

appimageTools.wrapType2 (finalAttrs: {
  pname = "plexamp";
  version = "4.13.2";
  src = fetchurl {
    url = "https://plexamp.plex.tv/plexamp.plex.tv/desktop/Plexamp-${finalAttrs.version}.AppImage";
    name = "${finalAttrs.pname}-${finalAttrs.version}.AppImage";
    hash = "sha512-Ww/QfMgmeghthfuGfc4Plv7vUKLikLf4R+SImG6TuYg0pDJ5psuHtXQezV0BurVRm6eQ+Ori+YGK2A52tCkcfw==";
  };

  extraInstallCommands = ''
    install -m 444 -D ${finalAttrs.contents}/plexamp.desktop $out/share/applications/plexamp.desktop
    install -m 444 -D ${finalAttrs.contents}/plexamp.svg \
      $out/share/icons/hicolor/scalable/apps/plexamp.svg
    substituteInPlace $out/share/applications/${finalAttrs.pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${finalAttrs.pname}'
    source "${makeWrapper}/nix-support/setup-hook"
    wrapProgram "$out/bin/plexamp" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"
  '';

  passthru.updateScript = ./update-plexamp.sh;

  meta = {
    description = "Beautiful Plex music player for audiophiles, curators, and hipsters";
    homepage = "https://plexamp.com/";
    changelog = "https://forums.plex.tv/t/plexamp-release-notes/221280/84";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      killercup
      redhawk
    ];
    platforms = [ "x86_64-linux" ];
  };
})
