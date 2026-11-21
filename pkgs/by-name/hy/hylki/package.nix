{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook4,
  dbus,
  glib,
  gpgme,
  gtk4,
  libadwaita,
  libgpg-error,
  libsoup_3,
  openssl,
  poppler,
  shared-mime-info,
  sqlite,
  webkitgtk_6_0,
  gsettings-desktop-schemas,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hylki";
  version = "1.43.1";

  src = fetchFromGitHub {
    owner = "hyprlab";
    repo = "hylki";
    tag = "v${finalAttrs.version}";
    hash = "sha256-E+jNQ651OPuvWqX8SBmd88IZmNi6m0FHHQGRYQO0swI=";
  };

  cargoHash = "sha256-MPi5hPsbi4qvxwlMCxPqgu0tBYXxuxMxCmSE8esakak=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
    # build.rs calls glib_build_tools::compile_resources for the icon,
    # sender-logo and notification-sound gresource bundles.
    glib
    shared-mime-info
  ];

  buildInputs = [
    dbus
    glib
    gpgme
    gtk4
    gsettings-desktop-schemas
    libadwaita
    libgpg-error
    libsoup_3
    openssl
    poppler
    sqlite
    webkitgtk_6_0
  ];

  # Two tests resolve attachment MIME types through the shared MIME database
  # and get application/octet-stream instead of application/pdf without it.
  preCheck = ''
    export XDG_DATA_DIRS="${shared-mime-info}/share"
  '';

  postInstall = ''
    for d in data/*.desktop; do
      [ -e "$d" ] || continue
      install -Dm444 "$d" "$out/share/applications/$(basename "$d")"
    done
    for g in data/*.gschema.xml; do
      [ -e "$g" ] || continue
      install -Dm444 "$g" "$out/share/glib-2.0/schemas/$(basename "$g")"
    done
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "GNOME-native email client built with Rust and libadwaita";
    homepage = "https://hyprlab.co/hylki/";
    changelog = "https://github.com/hyprlab/hylki/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    mainProgram = "hylki";
    maintainers = with lib.maintainers; [ gburd ];
    platforms = lib.platforms.linux;
  };
})
