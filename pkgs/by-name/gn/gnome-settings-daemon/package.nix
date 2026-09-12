{
  alsa-lib,
  bashNonInteractive,
  buildPackages,
  colord,
  cups,
  fetchurl,
  fontconfig,
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
  libgudev,
  libgweather,
  libnotify,
  libpulseaudio,
  libx11,
  libxfixes,
  meson,
  modemmanager,
  networkmanager,
  ninja,
  perl,
  pkg-config,
  polkit,
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

  __structuredAttrs = true;
  strictDeps = true;

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
    gettext
    glib
    meson
    ninja
    perl
    pkg-config
    udevCheckHook
    wrapGAppsNoGuiHook
  ];

  buildInputs = [
    alsa-lib
    bashNonInteractive
    colord
    cups
    fontconfig
    gcr_4
    geoclue2
    geocode-glib_2
    glib
    gnome-desktop
    gsettings-desktop-schemas
    libcanberra
    libgudev
    libgweather
    libnotify
    libpulseaudio
    libx11
    libxfixes
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
    description = "GNOME Settings Daemon";
    homepage = "https://gitlab.gnome.org/GNOME/gnome-settings-daemon/";
    license = lib.licenses.gpl2Plus;
    teams = [ lib.teams.gnome ];
    platforms = lib.platforms.linux;
  };
})
