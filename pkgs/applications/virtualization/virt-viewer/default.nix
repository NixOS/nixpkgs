{ stdenv, fetchurl, pkgconfig, intltool, glib, libxml2, gtk3, gtkvnc, gmp
, libgcrypt, gnupg, cyrus_sasl, shared_mime_info, libvirt, libcap_ng, yajl
, gsettings_desktop_schemas, makeWrapper, xen, numactl, libvirt-glib
, spiceSupport ? true, spice_gtk ? null, spice_protocol ? null, libcap ? null, gdbm ? null
}:

assert spiceSupport ->
  spice_gtk != null && spice_protocol != null && libcap != null && gdbm != null;

with stdenv.lib;

stdenv.mkDerivation rec {
  baseName = "virt-viewer";
  version = "5.0";
  name = "${baseName}-${version}";

  src = fetchurl {
    url = "http://virt-manager.org/download/sources/${baseName}/${name}.tar.gz";
    sha256 = "0blbp1wkw8ahss9va0bmcz2yx18j0mvm6fzrzhh2ly3sja5ysb8b";
  };

  buildInputs = [
    pkgconfig intltool glib libxml2 gtk3 gtkvnc gmp libgcrypt gnupg cyrus_sasl
    shared_mime_info libvirt libcap_ng yajl gsettings_desktop_schemas makeWrapper
    numactl libvirt-glib
  ] ++ optionals spiceSupport [ spice_gtk spice_protocol libcap gdbm
  ] ++ optional (stdenv.system == "x86_64-linux") xen;

  postInstall = ''
    for f in "$out"/bin/*; do
        wrapProgram "$f" --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
    done
  '';

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
