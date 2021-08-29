{ lib, stdenv, fetchurl, pkg-config, intltool, shared-mime-info, wrapGAppsHook
, glib, gsettings-desktop-schemas, gtk-vnc, gtk3, libvirt, libvirt-glib, libxml2, vte
, spiceSupport ? true
, spice-gtk ? null, spice-protocol ? null, libcap ? null, gdbm ? null
}:

assert spiceSupport ->
  spice-gtk != null && spice-protocol != null && libcap != null && gdbm != null;

with lib;

stdenv.mkDerivation rec {
  baseName = "virt-viewer";
  version = "9.0";
  name = "${baseName}-${version}";

  src = fetchurl {
    url = "http://virt-manager.org/download/sources/${baseName}/${name}.tar.gz";
    sha256 = "09a83mzyn3b4nd7wpa659g1zf1fjbzb79rk968bz6k5xl21k7d4i";
  };

  nativeBuildInputs = [ pkg-config intltool shared-mime-info wrapGAppsHook glib ];
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
