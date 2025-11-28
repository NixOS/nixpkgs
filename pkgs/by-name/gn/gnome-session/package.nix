{
  fetchurl,
  lib,
  stdenv,
  replaceVars,
  meson,
  ninja,
  pkg-config,
  gnome,
  gobject-introspection,
  adwaita-icon-theme,
  glib,
  gtk4,
  gsettings-desktop-schemas,
  gnome-desktop,
  gnome-settings-daemon,
  gnome-shell,
  dbus,
  json-glib,
  libICE,
  xmlto,
  docbook_xsl,
  docbook_xml_dtd_45,
  python3,
  libxslt,
  gettext,
  systemd,
  xorg,
  libepoxy,
  gnome-session-ctl,
  wrapGAppsHook4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-session";
  # Also bump ./ctl.nix when bumping major version.
  version = "49.2";

  outputs = [
    "out"
    "sessions"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-session/${lib.versions.major finalAttrs.version}/gnome-session-${finalAttrs.version}.tar.xz";
    hash = "sha256-/NtPRdamDYTp7K4eN0C6tuVbqwy0ng+zgoDps486hIU=";
  };

  patches = [
    # https://github.com/NixOS/nixpkgs/pull/48517
    ./nixos_set_environment_done.patch
  ];

  nativeBuildInputs = [
    gobject-introspection.setupHook
    meson
    ninja
    pkg-config
    gettext
    xmlto
    libxslt
    docbook_xsl
    docbook_xml_dtd_45
    python3
    dbus # for DTD
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    gtk4
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

    # Use our provided `gnome-session-ctl`
    original="@libexecdir@/gnome-session-ctl"
    replacement="${gnome-session-ctl}/libexec/gnome-session-ctl"

    find data/ -type f -name "*.service.in" -exec sed -i \
      -e s,$original,$replacement,g \
      {} +
  '';

  # We move the GNOME sessions to another output since gnome-session is a dependency of
  # GDM itself. If we do not hide them, it will show broken GNOME sessions when GDM is
  # enabled without proper GNOME installation.
  postInstall = ''
    mkdir $sessions
    moveToOutput share/wayland-sessions "$sessions"
    moveToOutput share/xsessions "$sessions"

    # Our provided one is being used
    rm -rf $out/libexec/gnome-session-ctl
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --suffix XDG_DATA_DIRS : "${gnome-shell}/share"
      --suffix XDG_CONFIG_DIRS : "${gnome-settings-daemon}/etc/xdg"
    )
  '';

  separateDebugInfo = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-session";
    };
    providedSessions = [
      "gnome"
    ];
  };

  meta = with lib; {
    description = "GNOME session manager";
    homepage = "https://gitlab.gnome.org/GNOME/gnome-session";
    changelog = "https://gitlab.gnome.org/GNOME/gnome-session/-/blob/${finalAttrs.version}/NEWS?ref_type=tags";
    license = licenses.gpl2Plus;
    teams = [ teams.gnome ];
    platforms = platforms.linux;
  };
})
