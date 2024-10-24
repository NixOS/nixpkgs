{ lib
, stdenv
, gettext
, fetchurl
, pkg-config
, gtkmm4
, libxml2
, bash
, gtk4
, libadwaita
, glib
, wrapGAppsHook4
, meson
, ninja
, gsettings-desktop-schemas
, itstool
, gnome
, adwaita-icon-theme
, librsvg
, gdk-pixbuf
, libgtop
, systemd
}:

stdenv.mkDerivation rec {
  pname = "gnome-system-monitor";
  version = "46.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-system-monitor/${lib.versions.major version}/gnome-system-monitor-${version}.tar.xz";
    hash = "sha256-U3YkgVjGhsMIJVRy6MKp5MFyVWQsFJ/HGYxtA05UdZk=";
  };

  patches = [
    # Fix pkexec detection on NixOS.
    ./fix-paths.patch
  ];

  nativeBuildInputs = [
    pkg-config
    gettext
    itstool
    wrapGAppsHook4
    meson
    ninja
    glib
  ];

  buildInputs = [
    bash
    gtk4
    libadwaita
    glib
    libxml2
    gtkmm4
    libgtop
    gdk-pixbuf
    adwaita-icon-theme
    librsvg
    gsettings-desktop-schemas
    systemd
  ];

  doCheck = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-system-monitor";
    };
  };

  meta = with lib; {
    homepage = "https://apps.gnome.org/SystemMonitor/";
    description = "System Monitor shows you what programs are running and how much processor time, memory, and disk space are being used";
    mainProgram = "gnome-system-monitor";
    maintainers = teams.gnome.members;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
