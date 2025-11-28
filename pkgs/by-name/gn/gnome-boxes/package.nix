{
  stdenv,
  lib,
  fetchurl,
  meson,
  ninja,
  wrapGAppsHook3,
  pkg-config,
  gettext,
  itstool,
  libvirt-glib,
  glib,
  gobject-introspection,
  libxml2,
  gtk3,
  libvirt,
  spice-gtk,
  spice-protocol,
  libhandy,
  libsoup_3,
  libosinfo,
  systemd,
  vala,
  libcap,
  yajl,
  gmp,
  gdbm,
  cyrus_sasl,
  gnome,
  adwaita-icon-theme,
  librsvg,
  desktop-file-utils,
  mtools,
  cdrkit,
  libcdio,
  libusb1,
  libarchive,
  acl,
  libgudev,
  libcap_ng,
  numactl,
  libapparmor,
  json-glib,
  webkitgtk_4_1,
  vte,
  glib-networking,
  qemu-utils,
  libportal-gtk3,
}:

stdenv.mkDerivation rec {
  pname = "gnome-boxes";
  version = "49.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-boxes/${lib.versions.major version}/gnome-boxes-${version}.tar.xz";
    hash = "sha256-VUeIAd3Qg4IL0yMZKoN04E879CoOcSYy0F5olVMORMo=";
  };

  patches = [
    # Fix path to libgovf-0.1.so in the gir file. We patch gobject-introspection to hardcode absolute paths but
    # our Meson patch will only pass the info when install_dir is absolute as well.
    ./fix-gir-lib-path.patch
  ];

  doCheck = true;

  nativeBuildInputs = [
    gettext
    gobject-introspection
    itstool
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook3
    # For post install script
    glib
    gtk3
    desktop-file-utils
  ];

  # Required for USB redirection PolicyKit rules file
  propagatedUserEnvPkgs = [ spice-gtk ];

  buildInputs = [
    acl
    cyrus_sasl
    gdbm
    glib
    glib-networking
    gmp
    adwaita-icon-theme
    gtk3
    json-glib
    libapparmor
    libarchive
    libcap
    libcap_ng
    libgudev
    libhandy
    libosinfo
    librsvg
    libsoup_3
    libusb1
    libvirt
    libvirt-glib
    libxml2
    numactl
    spice-gtk
    spice-protocol
    systemd
    vte
    webkitgtk_4_1
    yajl
    libportal-gtk3
  ];

  preFixup = ''
    gappsWrapperArgs+=(--prefix PATH : "${
      lib.makeBinPath [
        mtools
        cdrkit
        libcdio
        qemu-utils
      ]
    }")
  '';

  passthru = {
    updateScript = gnome.updateScript { packageName = "gnome-boxes"; };
  };

  meta = with lib; {
    description = "Simple GNOME 3 application to access remote or virtual systems";
    mainProgram = "gnome-boxes";
    homepage = "https://apps.gnome.org/Boxes/";
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
    teams = [ teams.gnome ];
  };
}
