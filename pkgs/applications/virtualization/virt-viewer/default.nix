{ stdenv, fetchurl, pkgconfig, intltool, glib, libxml2, gtk3, gtkvnc, gmp
, libgcrypt, gnupg, cyrus_sasl, spiceSupport ? true, spice_gtk, shared_mime_info
, libvirt, libcap_ng, yajl
}:

with stdenv.lib;

let sourceInfo = rec {
    baseName="virt-viewer";
    version="1.0";
    name="${baseName}-${version}";
    url="http://virt-manager.org/download/sources/${baseName}/${name}.tar.gz";
    hash="09sf1xzvw2yysv4c1jkqlzrazdg501r4j12hiwjdzk5swk6lppw0";
}; in

stdenv.mkDerivation  {
  inherit (sourceInfo) name version;

  src = fetchurl {
    url = sourceInfo.url;
    sha256 = sourceInfo.hash;
  };

  buildInputs = [ 
    pkgconfig intltool glib libxml2 gtk3 gtkvnc gmp libgcrypt gnupg cyrus_sasl
    shared_mime_info libvirt libcap_ng yajl
  ] ++ optional spiceSupport spice_gtk;

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
