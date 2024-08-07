{
  stdenv,
  lib,
  fetchurl,
  substituteAll,
  dconf,
  gettext,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
  gnome,
  accountsservice,
  fontconfig,
  gdm,
  geoclue2,
  geocode-glib_2,
  glib,
  gnome-desktop,
  gtk4,
  libgweather,
  json-glib,
  krb5,
  libpwquality,
  libsecret,
  networkmanager,
  pango,
  polkit,
  webkitgtk_6_0,
  systemd,
  libadwaita,
  libnma-gtk4,
  tzdata,
  gnome-tecla,
  gsettings-desktop-schemas,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-initial-setup";
  version = "47.alpha";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-initial-setup/${lib.versions.major finalAttrs.version}/gnome-initial-setup-${finalAttrs.version}.tar.xz";
    hash = "sha256-u2MJymX7taLx5177GDDXI1Geo5gGIE5AcskEzF6yvqs=";
  };

  patches = [
    (substituteAll {
      src = ./0001-fix-paths.patch;
      inherit tzdata;
      tecla = gnome-tecla;
    })
  ];

  nativeBuildInputs = [
    dconf
    gettext
    meson
    ninja
    pkg-config
    systemd
    wrapGAppsHook4
  ];

  buildInputs = [
    accountsservice
    fontconfig
    gdm
    geoclue2
    geocode-glib_2
    glib
    gnome-desktop
    gsettings-desktop-schemas
    gtk4
    json-glib
    krb5
    libgweather
    libadwaita
    libnma-gtk4
    libpwquality
    libsecret
    networkmanager
    pango
    polkit
    webkitgtk_6_0
  ];

  mesonFlags = [
    "-Dibus=disabled"
    "-Dparental_controls=disabled"
    "-Dvendor-conf-file=${./vendor.conf}"
  ];

  passthru = {
    updateScript = gnome.updateScript { packageName = "gnome-initial-setup"; };
  };

  meta = with lib; {
    description = "Simple, easy, and safe way to prepare a new system";
    homepage = "https://gitlab.gnome.org/GNOME/gnome-initial-setup";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = teams.gnome.members;
  };
})
