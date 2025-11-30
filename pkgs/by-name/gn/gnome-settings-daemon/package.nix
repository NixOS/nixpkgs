{
  stdenv,
  lib,
  replaceVars,
  buildPackages,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  gnome,
  perl,
  gettext,
  glib,
  libnotify,
  libgnomekbd,
  libpulseaudio,
  alsa-lib,
  libcanberra,
  upower,
  colord,
  libgweather,
  polkit,
  gsettings-desktop-schemas,
  geoclue2,
  systemd,
  libgudev,
  libxslt,
  libxml2,
  modemmanager,
  networkmanager,
  gnome-desktop,
  geocode-glib_2,
  docbook-xsl-nons,
  wrapGAppsNoGuiHook,
  python3,
  tzdata,
  gcr_4,
  gnome-session-ctl,
  udevCheckHook,
  withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-settings-daemon";
  version = "49.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-settings-daemon/${lib.versions.major finalAttrs.version}/gnome-settings-daemon-${finalAttrs.version}.tar.xz";
    hash = "sha256-KplX/E+Rw7kSe0lIQXm+9IUSDZwcII5E1E5qdG5swcE=";
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
    meson
    ninja
    pkg-config
    perl
    gettext
    glib
    libxml2
    libxslt
    docbook-xsl-nons
    wrapGAppsNoGuiHook
    python3
    udevCheckHook
  ];

  buildInputs = [
    glib
    gsettings-desktop-schemas
    modemmanager
    networkmanager
    libnotify
    libgnomekbd # for org.gnome.libgnomekbd.keyboard schema
    gnome-desktop
    libpulseaudio
    alsa-lib
    libcanberra
    upower
    colord
    libgweather
    polkit
    geocode-glib_2
    geoclue2
    libgudev
    gcr_4
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

  meta = with lib; {
    license = licenses.gpl2Plus;
    teams = [ teams.gnome ];
    platforms = platforms.linux;
  };
})
