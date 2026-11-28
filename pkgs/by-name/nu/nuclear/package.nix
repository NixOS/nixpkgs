{
  appimageTools,
  lib,
  fetchurl,
  makeWrapper,
}:
appimageTools.wrapType2 (finalAttrs: {
  pname = "nuclear";
  version = "1.54.2";
  src = fetchurl {
    # Nuclear currently only publishes AppImage releases for x86_64, which is hardcoded in
    # the release asset name. We also hardcode the host arch in the release name, but should
    # upstream provide more arches, we should use stdenv.hostPlatform to determine the arch
    # and choose the source URL accordingly.
    url = "https://github.com/nukeop/nuclear/releases/download/player@${finalAttrs.version}/Nuclear_${finalAttrs.version}_amd64.AppImage";
    hash = "sha256-WpjywoxB++moGFr9EQZNK9ETFs/nPhIrHnxHx6CCS0s=";
  };

  nativeBuildInputs = [ makeWrapper ];

  extraInstallCommands = ''
    install -m 444 -D ${finalAttrs.contents}/Nuclear.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/Nuclear.desktop \
      --replace-fail 'Exec=nuclear-music-player' 'Exec=${finalAttrs.pname}'
    cp -r ${finalAttrs.contents}/usr/share/icons $out/share

    # The AppImage bundles its own GLib (2.72), which cannot load GIO modules built
    # against the much newer GLib in nixpkgs. NixOS' dconf, gvfs and glib-networking
    # modules are all exported through GIO_EXTRA_MODULES, so they leak into the
    # AppImage's environment and fail to load. Drop it and rely on the modules the
    # AppImage ships instead, which are built against its own GLib.
    wrapProgram $out/bin/${finalAttrs.pname} --unset GIO_EXTRA_MODULES
  '';

  # The bundled libsecret/libgcrypt need libgpg-error, which upstream does not ship.
  extraPkgs = pkgs: [ pkgs.libgpg-error ];

  # buildFHSEnv puts nixpkgs' GStreamer plugin directory at the front of
  # GST_PLUGIN_SYSTEM_PATH_1_0, so WebKit's helper processes scan it alongside the
  # AppImage's own plugins. The AppImage bundles GStreamer 1.20 against GLib 2.72,
  # while nixpkgs' plugins need 1.28/GLib 2.88, so every one of them fails to load
  # with an undefined symbol. Drop them; only the bundled plugins can be used.
  extraBuildCommands = ''
    rm -rf $out/usr/lib64/gstreamer-1.0
  '';

  meta = {
    description = "Streaming music player that finds free music for you";
    homepage = "https://nuclearplayer.com";
    license = lib.licenses.agpl3Plus;
    maintainers = [ lib.maintainers.NotAShelf ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "nuclear";
  };
})
