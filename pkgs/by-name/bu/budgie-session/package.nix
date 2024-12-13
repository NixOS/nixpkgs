{
  lib,
  stdenv,
  fetchFromGitHub,
  substituteAll,
  meson,
  ninja,
  pkg-config,
  adwaita-icon-theme,
  glib,
  gtk3,
  gsettings-desktop-schemas,
  gnome-desktop,
  gnome-settings-daemon,
  dbus,
  json-glib,
  libICE,
  xmlto,
  docbook_xsl,
  docbook_xml_dtd_412,
  python3,
  libxslt,
  gettext,
  makeWrapper,
  nix-update-script,
  systemd,
  xorg,
  libepoxy,
  bash,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "budgie-session";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "BuddiesOfBudgie";
    repo = "budgie-session";
    rev = "v${finalAttrs.version}";
    hash = "sha256-mz+Yh3NK2Tag+MWVofFFXYYXspxhmYBD6YCiuATpZSI=";
  };

  outputs = [
    "out"
    "man"
  ];

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      gsettings = lib.getExe' glib "gsettings";
      dbusLaunch = lib.getExe' dbus "dbus-launch";
      bash = lib.getExe bash;
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    makeWrapper
    xmlto
    libxslt
    docbook_xsl
    docbook_xml_dtd_412
    python3
    dbus # for DTD
  ];

  buildInputs = [
    glib
    gtk3
    libICE
    gnome-desktop
    json-glib
    xorg.xtrans
    adwaita-icon-theme
    gnome-settings-daemon
    gsettings-desktop-schemas
    systemd
    libepoxy
  ];

  postPatch = ''
    chmod +x meson_post_install.py # patchShebangs requires executable file
    patchShebangs meson_post_install.py
  '';

  # `bin/budgie-session` will reset the environment when run in wayland, we
  # therefor wrap `libexec/budgie-session-binary` instead which is the actual
  # binary needing wrapping
  preFixup = ''
    wrapProgram "$out/libexec/budgie-session-binary" \
      --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH" \
      --suffix XDG_DATA_DIRS : "$out/share:$GSETTINGS_SCHEMAS_PATH" \
      --suffix XDG_CONFIG_DIRS : "${gnome-settings-daemon}/etc/xdg"
  '';

  separateDebugInfo = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Session manager for Budgie";
    homepage = "https://github.com/BuddiesOfBudgie/budgie-session";
    changelog = "https://github.com/BuddiesOfBudgie/budgie-session/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl2Plus;
    maintainers = lib.teams.budgie.members;
    platforms = lib.platforms.linux;
  };
})
