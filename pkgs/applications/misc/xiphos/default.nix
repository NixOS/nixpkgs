{stdenv, fetchurl, pkgconfig
, python
, intltool
, docbook2x, docbook_xml_dtd_412, libxslt
, sword, clucene_core
, gnome_doc_utils
, libgsf, gconf
, gtkhtml, libgtkhtml, libglade, scrollkeeper
, webkitgtk
, dbus_glib, enchant, isocodes, libuuid
}:

stdenv.mkDerivation rec {
  name = "xiphos-${version}";  
  version = "3.2.2";

  src = fetchurl {
    url = "http://downloads.sourceforge.net/project/gnomesword/Xiphos/${version}/${name}.tar.gz";
    sha256 = "1imd3v8knb5y3kddlfzp67p927zpfy0adjri89n7vcnipb9fy9i3";
  };

  buildInputs = [ pkgconfig python intltool docbook2x docbook_xml_dtd_412 libxslt
                  sword clucene_core gnome_doc_utils libgsf gconf gtkhtml libgtkhtml
                  libglade scrollkeeper webkitgtk dbus_glib enchant isocodes libuuid ];

  prePatch = ''
    patchShebangs .;
  '';

  preConfigure =  ''
    export CLUCENE_HOME=${clucene_core};
    export SWORD_HOME=${sword};
  '';
  
  configurePhase = ''
    python waf configure --prefix=$out    
  '';
  
  buildPhase = ''
    python waf build
  '';

  installPhase = ''
    python waf install
  '';

  meta = with stdenv.lib; {
    description = "A GTK Bible study tool";
    longDescription = ''
    Xiphos (formerly known as GnomeSword) is a Bible study tool
    written for Linux, UNIX, and Windows using GTK, offering a rich
    and featureful environment for reading, study, and research using
    modules from The SWORD Project and elsewhere.
    '';
    homepage = http://www.xiphos.org/;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}
