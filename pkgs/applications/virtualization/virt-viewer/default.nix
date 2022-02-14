{ lib
, stdenv
, fetchurl
, gdbm ? null
, glib
, gsettings-desktop-schemas
, gtk-vnc
, gtk3
, intltool
, libcap ? null
, libvirt
, libvirt-glib
, libxml2
, pkg-config
, shared-mime-info
, spice-gtk ? null
, spice-protocol ? null
, spiceSupport ? true
, vte
, wrapGAppsHook
}:

assert spiceSupport -> (
  gdbm != null
  && libcap != null
  && spice-gtk != null
  && spice-protocol != null
);

with lib;

stdenv.mkDerivation rec {
  baseName = "virt-viewer";
  version = "9.0";
  name = "${baseName}-${version}";

  src = fetchurl {
    url = "http://virt-manager.org/download/sources/${baseName}/${name}.tar.gz";
    sha256 = "09a83mzyn3b4nd7wpa659g1zf1fjbzb79rk968bz6k5xl21k7d4i";
  };

  nativeBuildInputs = [
    glib
    intltool
    pkg-config
    shared-mime-info
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    gsettings-desktop-schemas
    gtk-vnc
    gtk3
    libvirt
    libvirt-glib
    libxml2
    vte
  ] ++ optionals spiceSupport [
    gdbm
    libcap
    spice-gtk
    spice-protocol
  ];

  # Required for USB redirection PolicyKit rules file
  propagatedUserEnvPkgs = optional spiceSupport spice-gtk;

  strictDeps = true;
  enableParallelBuilding = true;

  meta = {
    description = "A viewer for remote virtual machines";
    maintainers = [ maintainers.raskin ];
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://virt-manager.org/download.html";
    };
  };
}
