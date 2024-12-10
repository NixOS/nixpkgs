{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  gettext,
  pkg-config,
  networkmanager,
  gnome,
  adwaita-icon-theme,
  libsecret,
  polkit,
  modemmanager,
  libnma,
  glib-networking,
  gsettings-desktop-schemas,
  libgudev,
  jansson,
  wrapGAppsHook3,
  gobject-introspection,
  python3,
  gtk3,
  libayatana-appindicator,
  glib,
}:

stdenv.mkDerivation rec {
  pname = "network-manager-applet";
  version = "1.36.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-qEcESH6jr+FIXEf7KrWYuPd59UCuDcvwocX4XmSn4lM=";
  };

  mesonFlags = [
    "-Dselinux=false"
    "-Dappindicator=yes"
  ];

  outputs = [
    "out"
    "man"
  ];

  buildInputs = [
    libnma
    gtk3
    networkmanager
    libsecret
    gsettings-desktop-schemas
    polkit
    libgudev
    modemmanager
    jansson
    glib
    glib-networking
    libayatana-appindicator
    adwaita-icon-theme
  ];

  nativeBuildInputs = [
    meson
    ninja
    gettext
    pkg-config
    wrapGAppsHook3
    gobject-introspection
    python3
  ];

  postPatch = ''
    chmod +x meson_post_install.py # patchShebangs requires executable file
    patchShebangs meson_post_install.py
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "networkmanagerapplet";
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/network-manager-applet/";
    description = "NetworkManager control applet for GNOME";
    license = licenses.gpl2Plus;
    maintainers = [ ];
    mainProgram = "nm-applet";
    platforms = platforms.linux;
  };
}
