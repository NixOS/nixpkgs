{ stdenv, fetchurl, pkgconfig, intltool, shared-mime-info, wrapGAppsHook
, glib, gsettings-desktop-schemas, gtk-vnc, gtk3, libvirt, libvirt-glib, libxml2, vte
, spiceSupport ? true
, spice-gtk ? null, spice-protocol ? null, libcap ? null, gdbm ? null
}:

assert spiceSupport ->
  spice-gtk != null && spice-protocol != null && libcap != null && gdbm != null;

with stdenv.lib;

stdenv.mkDerivation rec {
  baseName = "virt-viewer";
  version = "8.0";
  name = "${baseName}-${version}";

  src = fetchurl {
    url = "http://virt-manager.org/download/sources/${baseName}/${name}.tar.gz";
    sha256 = "1vdnjmhrva7r1n9nv09j8gc12hy0j9j5l4rka4hh0jbsbpnmiwyw";
  };

  nativeBuildInputs = [ pkgconfig intltool shared-mime-info wrapGAppsHook glib ];
  buildInputs = [
    glib gsettings-desktop-schemas gtk-vnc gtk3 libvirt libvirt-glib libxml2 vte
  ] ++ optionals spiceSupport [
    spice-gtk spice-protocol libcap gdbm
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
