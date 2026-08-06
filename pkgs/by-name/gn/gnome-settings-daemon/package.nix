{
  alsa-lib,
  buildPackages,
  colord,
  docbook-xsl-nons,
  fetchpatch,
  fetchurl,
  gcr_4,
  geoclue2,
  geocode-glib_2,
  gettext,
  glib,
  gnome,
  gnome-desktop,
  gnome-session-ctl,
  gsettings-desktop-schemas,
  lib,
  libcanberra,
  libgnomekbd,
  libgudev,
  libgweather,
  libnotify,
  libpulseaudio,
  libxml2,
  libxslt,
  meson,
  modemmanager,
  networkmanager,
  ninja,
  perl,
  pkg-config,
  polkit,
  python3,
  replaceVars,
  stdenv,
  systemd,
  tzdata,
  udevCheckHook,
  upower,
  wrapGAppsNoGuiHook,
  withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-settings-daemon";
  version = "50.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-settings-daemon/${lib.versions.major finalAttrs.version}/gnome-settings-daemon-${finalAttrs.version}.tar.xz";
    hash = "sha256-3SyXMJFPDs7KAindiowpQKV93rCAJDRVjUsWTXnP4Fw=";
  };

  patches = [
    # https://gitlab.gnome.org/GNOME/gnome-settings-daemon/-/merge_requests/202
    ./add-gnome-session-ctl-option.patch

    (replaceVars ./fix-paths.patch {
      inherit tzdata;
    })
  ];

  depsBuildBuild = [
    buildPackages.stdenv.cc
    pkg-config
  ];

  nativeBuildInputs = [
    docbook-xsl-nons
    gettext
    glib
    libxml2
    libxslt
    meson
    ninja
    perl
    pkg-config
    python3
    udevCheckHook
    wrapGAppsNoGuiHook
  ];

  buildInputs = [
    alsa-lib
    colord
    gcr_4
    geoclue2
    geocode-glib_2
    glib
    gnome-desktop
    gsettings-desktop-schemas
    libcanberra
    libgnomekbd # for org.gnome.libgnomekbd.keyboard schema
    libgudev
    libgweather
    libnotify
    libpulseaudio
    modemmanager
    networkmanager
    polkit
    upower
  ]
  ++ lib.optionals withSystemd [
    systemd
  ];

  mesonFlags = [
    "-Dudev_dir=${placeholder "out"}/lib/udev"
    (lib.mesonBool "systemd" withSystemd)
  ]
  ++ lib.optionals withSystemd [
    "-Dgnome_session_ctl_path=${gnome-session-ctl}/libexec/gnome-session-ctl"
  ];

  # Default for release buildtype but passed manually because
  # we're using plain
  env.NIX_CFLAGS_COMPILE = "-DG_DISABLE_CAST_CHECKS";

  postPatch = ''
    for f in plugins/power/gsd-power-constants-update.pl; do
      chmod +x $f
      patchShebangs $f
    done
  '';

  doInstallCheck = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-settings-daemon";
    };
  };

  meta = {
    license = lib.licenses.gpl2Plus;
    teams = [ lib.teams.gnome ];
    platforms = lib.platforms.linux;
  };
})
