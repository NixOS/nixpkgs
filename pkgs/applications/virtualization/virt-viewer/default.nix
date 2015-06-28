{ stdenv, fetchurl, pkgconfig, intltool, glib, libxml2, gtk3, gtkvnc, gmp
, libgcrypt, gnupg, cyrus_sasl, shared_mime_info, libvirt, libcap_ng, yajl
, gsettings_desktop_schemas, makeWrapper
, spiceSupport ? true, spice_gtk ? null, spice_protocol ? null, libcap ? null, gdbm ? null
}:

assert spiceSupport ->
  spice_gtk != null && spice_protocol != null && libcap != null && gdbm != null;

with stdenv.lib;

let sourceInfo = rec {
    baseName="virt-viewer";
    version="2.0";
    name="${baseName}-${version}";
    url="http://virt-manager.org/download/sources/${baseName}/${name}.tar.gz";
    hash="0dylhpk5rq9jz0l1cxs50q2s74z0wingygm1m33bmnmcnny87ig9";
}; in

stdenv.mkDerivation  {
  inherit (sourceInfo) name version;

  src = fetchurl {
    url = sourceInfo.url;
    sha256 = sourceInfo.hash;
  };

  buildInputs = [ 
    pkgconfig intltool glib libxml2 gtk3 gtkvnc gmp libgcrypt gnupg cyrus_sasl
    shared_mime_info libvirt libcap_ng yajl gsettings_desktop_schemas makeWrapper
  ] ++ optionals spiceSupport [ spice_gtk spice_protocol libcap gdbm ];

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
