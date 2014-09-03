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
  version = "3.2.1";

  src = fetchurl {
    url = "http://downloads.sourceforge.net/project/gnomesword/Xiphos/${version}/${name}.tar.gz";
    sha256 = "0xff31f89as1p7fn3vq8ishjhbmx6qhc25msh5ypa0zg8hm5dxbb";
  };

  buildInputs = [ pkgconfig python intltool docbook2x docbook_xml_dtd_412 libxslt sword clucene_core gnome_doc_utils libgsf gconf gtkhtml libgtkhtml libglade scrollkeeper webkitgtk dbus_glib enchant isocodes libuuid ];

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

  meta =  {
    description = "A GTK Bible study tool";
    longDescription = ''
    Xiphos (formerly known as GnomeSword) is a Bible study tool written for Linux, UNIX,
    and Windows using GTK, offering a rich and featureful environment for reading, study,
    and research using modules from The SWORD Project and elsewhere.    
    '';
    homepage = http://www.xiphos.org/;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [ stdenv.lib.maintainers.AndersonTorres ];
    platforms = stdenv.lib.platforms.linux;
  };
}
