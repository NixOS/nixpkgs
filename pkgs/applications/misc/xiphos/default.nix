{stdenv, fetchurl, pkgconfig
, python
, intltool
, docbook2x, docbook_xml_dtd_412, libxslt
, sword, clucene_core, biblesync
, gnome_doc_utils
, libgsf, gconf
, gtkhtml, libgtkhtml, libglade, scrollkeeper
, webkitgtk
, dbus_glib, enchant, isocodes, libuuid
}:

stdenv.mkDerivation rec {
  name = "xiphos-${version}";  
  version = "4.0.3-20150806";

  src = fetchurl {
    url = "mirror://sourceforge/project/gnomesword/Xiphos/4.0.3/${name}.tar.gz";
    sha256 = "1xkvhpasdlda2rp0874znz158z4rjh1hpynwy13d96kjxq4npiqv";
  };

  buildInputs = [ pkgconfig python intltool docbook2x docbook_xml_dtd_412 libxslt
                  sword clucene_core biblesync gnome_doc_utils libgsf gconf gtkhtml libgtkhtml
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
