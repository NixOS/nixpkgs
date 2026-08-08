{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  wrapGAppsHook4,
  gtk4,
  librsvg,
  gsettings-desktop-schemas,
  hicolor-icon-theme,
}:

rustPlatform.buildRustPackage (finalAttrs:  {
  pname = "hwall";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "pulpul-s";
    repo = "HWall";
    tag = ${finalAttrs.version};
    hash = "sha256-4xl4WUgfa86YWoLxD0L7zVxzMddlDvNKbCi8z8JwqKo=";
  };

  cargoHash = "sha256-zQ4bbPV+ApX0Uq+BLLbqaCki9VZF1c5i8u160QBAAsY=";

  __structuredAttrs = true;
 
  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4 # sets XDG_DATA_DIRS, GDK_PIXBUF_MODULE_FILE, GIO_EXTRA_MODULES
  ];

  buildInputs = [
    gtk4 # propagates glib, pango, cairo, gdk-pixbuf, graphene, harfbuzz, ...
    librsvg # SVG loader for gdk-pixbuf (app icon)
    gsettings-desktop-schemas
    hicolor-icon-theme
  ];

  # The workspace produces both binaries: hwall (GTK) and hwall-cli (TUI).
  cargoBuildFlags = [
    "--workspace"
    "--locked"
  ];

  # Skip the helper-timeout test: it spawns /bin/sleep, which does not exist
  # inside the Nix build sandbox (only /bin/sh is provided).
  checkFlags = [
    "--skip"
    "times_out_and_reaps_slow_helpers"
  ];

  # Default cargoInstallHook copies the two built binaries (hwall, hwall-cli)
  # into $out/bin; here we add the desktop integration files.
  postInstall = ''
    install -Dm644 packaging/io.github.hwall.HWall.desktop \
      $out/share/applications/io.github.hwall.HWall.desktop
    install -Dm644 packaging/io.github.hwall.HWall.metainfo.xml \
      $out/share/metainfo/io.github.hwall.HWall.metainfo.xml
    install -Dm644 packaging/icons/hicolor/scalable/apps/io.github.hwall.HWall.svg \
      $out/share/icons/hicolor/scalable/apps/io.github.hwall.HWall.svg
    for size in 32 48 64; do
      install -Dm644 packaging/icons/hicolor/''${size}x''${size}/apps/io.github.hwall.HWall.png \
        $out/share/icons/hicolor/''${size}x''${size}/apps/io.github.hwall.HWall.png
    done
  '';

  meta = with lib; {
    description = "Linux hardware inventory and live sensor monitor";
    homepage = "https://github.com/pulpul-s/HWall";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "hwall";
    platforms = platforms.linux;
  };
}
