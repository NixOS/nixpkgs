{
  stdenv,
  lib,
  replaceVars,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  perl,
  gettext,
  gtk3,
  glib,
  libnotify,
  libgnomekbd,
  libpulseaudio,
  alsa-lib,
  libcanberra-gtk3,
  upower,
  colord,
  libgweather,
  polkit,
  gsettings-desktop-schemas,
  geoclue2,
  systemd,
  libgudev,
  libwacom,
  libxslt,
  libxml2,
  modemmanager,
  networkmanager,
  gnome-desktop,
  geocode-glib_2,
  docbook_xsl,
  wrapGAppsHook3,
  python3,
  tzdata,
  gcr_4,
  gnome-session-ctl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-settings-daemon";
  version = "46.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-settings-daemon/${lib.versions.major finalAttrs.version}/gnome-settings-daemon-${finalAttrs.version}.tar.xz";
    hash = "sha256-C5oPZPoYqOfgm0yVo/dU+gM8LNvS3DVwHwYYVywcs9c=";
  };

  patches = [
    # https://gitlab.gnome.org/GNOME/gnome-settings-daemon/-/merge_requests/202
    ./add-gnome-session-ctl-option.patch

    (replaceVars ./fix-paths.patch {
      inherit tzdata;
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    perl
    gettext
    libxml2
    libxslt
    docbook_xsl
    wrapGAppsHook3
    python3
  ];

  buildInputs = [
    gtk3
    glib
    gsettings-desktop-schemas
    modemmanager
    networkmanager
    libnotify
    libgnomekbd # for org.gnome.libgnomekbd.keyboard schema
    gnome-desktop
    libpulseaudio
    alsa-lib
    libcanberra-gtk3
    upower
    colord
    libgweather
    polkit
    geocode-glib_2
    geoclue2
    systemd
    libgudev
    libwacom
    gcr_4
  ];

  mesonFlags = [
    "-Dudev_dir=${placeholder "out"}/lib/udev"
    "-Dgnome_session_ctl_path=${gnome-session-ctl}/libexec/gnome-session-ctl"
  ];

  # Default for release buildtype but passed manually because
  # we're using plain
  env.NIX_CFLAGS_COMPILE = "-DG_DISABLE_CAST_CHECKS";

  postPatch = ''
    for f in gnome-settings-daemon/codegen.py plugins/power/gsd-power-constants-update.pl; do
      chmod +x $f
      patchShebangs $f
    done
  '';

  meta = with lib; {
    description = "GNOME Settings Daemon";
    homepage = "https://gitlab.gnome.org/GNOME/gnome-settings-daemon/";
    license = licenses.gpl2Plus;
    teams = [ teams.pantheon ];
    platforms = platforms.linux;
  };
})
