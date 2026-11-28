{
  stdenv,
  lib,
  fetchurl,
  at-spi2-core,
  gcr_4,
  glib,
  gobject-introspection,
  graphene,
  gsettings-desktop-schemas,
  gtk4,
  lcms2,
  libGL,
  libadwaita,
  libpwquality,
  libsecret,
  libsodium,
  libx11,
  libxfixes,
  libxkbcommon,
  libxi,
  meson,
  mutter,
  ninja,
  pango,
  pixman,
  pkg-config,
  sqlite,
  vala,
  wayland,
  desktop-file-utils,
  directoryListingUpdater,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gpaste";
  version = "51.3";

  src = fetchurl {
    url = "https://www.imagination-land.org/files/gpaste/GPaste-${finalAttrs.version}.tar.xz";
    hash = "sha256-rHtmsbojSPCfgwPhA+5VvSa9nf9y7YJWTEXd+eGJI+U=";
  };

  nativeBuildInputs = [
    gobject-introspection
    meson
    ninja
    pkg-config
    vala
    desktop-file-utils
    wrapGAppsHook3
  ];

  buildInputs = [
    gcr_4
    glib
    gtk4
    libadwaita
    pango

    # The meson setup hook builds with -Dauto_features=enabled, so the optional
    # features (history encryption, the SQLite storage backend, remembering the
    # passphrase in the keyring and the password strength rating) need their
    # dependencies present.
    libpwquality
    libsecret
    libsodium
    sqlite

    # The GNOME Shell extension also builds the opt-in in-shell daemon, which
    # links libmutter; these satisfy libmutter's pkg-config cflags.
    at-spi2-core # atk
    graphene
    gsettings-desktop-schemas
    lcms2 # required by mutter-clutter
    libGL # for gl, egl and glesv2
    libx11
    libxfixes
    libxkbcommon
    libxi
    mutter
    pixman
    wayland # wayland-server
  ];

  mesonFlags = [
    (lib.mesonOption "control-center-keybindings-dir" "${placeholder "out"}/share/gnome-control-center/keybindings")
    (lib.mesonOption "dbus-services-dir" "${placeholder "out"}/share/dbus-1/services")
    (lib.mesonOption "dbus-interfaces-dir" "${placeholder "out"}/share/dbus-1/interfaces")
    (lib.mesonOption "systemd-user-unit-dir" "${placeholder "out"}/etc/systemd/user")
  ];

  postInstall = ''
    # We do not have central location to install typelibs to,
    # let’s ensure GNOME Shell can still find them.
    extensionDir="$out/share/gnome-shell/extensions/GPaste@gnome-shell-extensions.gnome.org"
    mv "$extensionDir/"{extension,.extension-wrapped}.js
    mv "$extensionDir/"{prefs,.prefs-wrapped}.js
    substitute "${./wrapper.js}" "$extensionDir/extension.js" \
      --subst-var-by originalName "extension" \
      --subst-var-by typelibDir "${placeholder "out"}/lib/girepository-1.0"
    substitute "${./wrapper.js}" "$extensionDir/prefs.js" \
      --subst-var-by originalName "prefs" \
      --subst-var-by typelibDir "${placeholder "out"}/lib/girepository-1.0"
  '';

  passthru.updateScript = directoryListingUpdater { pname = "GPaste"; };

  meta = {
    homepage = "https://github.com/Keruspe/GPaste";
    changelog = "https://github.com/Keruspe/GPaste/blob/v${finalAttrs.version}/NEWS";
    description = "Clipboard management system with GNOME integration";
    mainProgram = "gpaste-client";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.gnome ];
    maintainers = with lib.maintainers; [ fabiob ];
  };
})
