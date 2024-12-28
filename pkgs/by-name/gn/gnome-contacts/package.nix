{
  lib,
  stdenv,
  gettext,
  fetchurl,
  evolution-data-server-gtk4,
  pkg-config,
  libxslt,
  docbook-xsl-nons,
  docbook_xml_dtd_42,
  desktop-file-utils,
  gtk4,
  glib,
  libportal-gtk4,
  gnome-online-accounts,
  qrencode,
  wrapGAppsHook4,
  folks,
  libxml2,
  gnome,
  vala,
  meson,
  ninja,
  libadwaita,
  gsettings-desktop-schemas,
  gst_all_1,
  pipewire,
}:

stdenv.mkDerivation rec {
  pname = "gnome-contacts";
  version = "47.1.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-contacts/${lib.versions.major version}/gnome-contacts-${version}.tar.xz";
    hash = "sha256-R+GuRbcEGgXV4nZJ2RLiwwAlYYisRg7cukaJnGYIpHg=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    gettext
    libxslt
    docbook-xsl-nons
    docbook_xml_dtd_42
    desktop-file-utils
    wrapGAppsHook4
  ];

  buildInputs = [
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-rs # GTK4 sink & paintable
    pipewire # pipewiresrc
    gtk4
    glib
    libportal-gtk4
    evolution-data-server-gtk4
    gsettings-desktop-schemas
    folks
    libadwaita
    libxml2
    gnome-online-accounts
    qrencode
  ];

  doCheck = true;

  passthru = {
    updateScript = gnome.updateScript { packageName = "gnome-contacts"; };
  };

  meta = with lib; {
    homepage = "https://apps.gnome.org/Contacts/";
    description = "GNOME’s integrated address book";
    mainProgram = "gnome-contacts";
    maintainers = teams.gnome.members;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
