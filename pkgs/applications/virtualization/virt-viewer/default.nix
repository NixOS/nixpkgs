{ stdenv, fetchurl, pkgconfig, intltool, glib, libxml2, gtk3, gtk-vnc, gmp
, libgcrypt, gnupg, cyrus_sasl, shared-mime-info, libvirt, yajl, xen
, gsettings-desktop-schemas, wrapGAppsHook, libvirt-glib, libcap_ng, numactl
, libapparmor, gst_all_1
, spiceSupport ? true
, spice-gtk ? null, spice-protocol ? null, libcap ? null, gdbm ? null
}:

assert spiceSupport ->
  spice-gtk != null && spice-protocol != null && libcap != null && gdbm != null;

with stdenv.lib;

stdenv.mkDerivation rec {
  baseName = "virt-viewer";
  version = "7.0";
  name = "${baseName}-${version}";

  src = fetchurl {
    url = "http://virt-manager.org/download/sources/${baseName}/${name}.tar.gz";
    sha256 = "00y9vi69sja4pkrfnvrkwsscm41bqrjzvp8aijb20pvg6ymczhj7";
  };

  nativeBuildInputs = [ pkgconfig intltool wrapGAppsHook ];
  buildInputs = [
    glib libxml2 gtk3 gtk-vnc gmp libgcrypt gnupg cyrus_sasl shared-mime-info
    libvirt yajl gsettings-desktop-schemas libvirt-glib
    libcap_ng numactl libapparmor
  ] ++ optionals stdenv.isx86_64 [
    xen
  ] ++ optionals spiceSupport [
    spice-gtk spice-protocol libcap gdbm
    gst_all_1.gst-plugins-base gst_all_1.gst-plugins-good
  ];

  # Required for USB redirection PolicyKit rules file
  propagatedUserEnvPkgs = optional spiceSupport spice-gtk;

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
