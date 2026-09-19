{
  stdenv,
  lib,
  fetchFromGitHub,
  gjs,
  glib,
  gobject-introspection,
  gtk3,
  gtk4,
  gcr_4,
  libadwaita,
  meson,
  ninja,
  nix-update-script,
  pango,
  pkg-config,
  vala,
  desktop-file-utils,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gpaste";
  version = "50.10";

  src = fetchFromGitHub {
    owner = "Keruspe";
    repo = "GPaste";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DyCuDtDy8z2F9PTWexWhCCH/GzmqvGLb1qadxfEzX5Y=";
  };

  # TODO: switch to substituteAll with placeholder
  # https://github.com/NixOS/nix/issues/1846
  postPatch = ''
    substituteInPlace src/libgpaste/gpaste/gpaste-settings.c \
      --subst-var-by gschemasCompiled ${glib.makeSchemaPath (placeholder "out") "${finalAttrs.pname}-${finalAttrs.version}"}
  '';

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
    gjs
    glib
    gtk4
    gcr_4
    libadwaita
    pango
  ];

  mesonFlags = [
    (lib.mesonOption "control-center-keybindings-dir" "${placeholder "out"}/share/gnome-control-center/keybindings")
    (lib.mesonOption "dbus-services-dir" "${placeholder "out"}/share/dbus-1/services")
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

  passthru.updateScript = nix-update-script { };

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
