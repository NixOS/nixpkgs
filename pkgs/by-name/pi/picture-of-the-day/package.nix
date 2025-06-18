{
  lib,
  rustPlatform,
  fetchFromGitea,
  pkg-config,
  wrapGAppsHook4,
  gettext,
  gobject-introspection,
  blueprint-compiler,
  desktop-file-utils,
  appstream-glib,
  glib,
  gtk4,
  libadwaita,
  libsoup_3,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "picture-of-the-day";
  version = "1.4.5";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "swsnr";
    repo = "picture-of-the-day";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ajLqT4t2xn9BfQJ3rGg/9TrdWgImwsmYGPI7wTVelTw=";
  };

  cargoHash = "sha256-NOczmWOVS34Yh+WUQ/RcnP+rBDQcaT8Encw+lZKGNlo=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
    gettext
    gobject-introspection
    blueprint-compiler
    appstream-glib
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    libsoup_3
  ];

  installPhase = ''
    install -Dm0644 de.swsnr.pictureoftheday.desktop $out/share/applications/de.swsnr.pictureoftheday.desktop
    install -Dm0644 resources/de.swsnr.pictureoftheday.metainfo.xml $out/share/metainfo/de.swsnr.pictureoftheday.metainfo.xml

    install -Dm0644 -t $out/share/icons/hicolor/scalable/apps/ resources/icons/scalable/apps/de.swsnr.pictureoftheday.svg
    install -Dm0644 resources/icons/symbolic/apps/de.swsnr.pictureoftheday-symbolic.svg \
      $out/share/icons/hicolor/symbolic/apps/de.swsnr.pictureoftheday-symbolic-symbolic.svg

    install -Dm0644 schemas/de.swsnr.pictureoftheday.gschema.xml $out/share/glib-2.0/schemas/de.swsnr.picture-of-the-day.gschema.xml
    glib-compile-schemas --strict $out/share/glib-2.0/schemas
  '';

  checkFlags = [
    # requires networking
    "--skip=images::sources::apod::tests::fetch_apod"
    "--skip=images::sources::bing::tests::fetch_daily_images"
    "--skip=images::sources::epod::tests::fetch_picture_of_the_day"
    "--skip=images::sources::epod::tests::scrape_page_with_asset_link_and_photographer"
    "--skip=images::sources::epod::tests::scrape_page_without_asset_link_and_copyright"
    "--skip=images::sources::wikimedia::tests::featured_image"
  ];

  meta = {
    description = "Your daily GNOME wallpaper";
    homepage = "https://codeberg.org/swsnr/picture-of-the-day";
    changelog = "https://codeberg.org/swsnr/picture-of-the-day/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mpl20;
    maintainers = [ lib.maintainers.awwpotato ];
    mainProgram = "picture-of-the-day";
  };
})
