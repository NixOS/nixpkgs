{stdenv, fetchFromGitHub, pkgconfig
, python
, intltool
, docbook2x, docbook_xml_dtd_412, libxslt
, sword, clucene_core, biblesync
, gnome_doc_utils
, libgsf, gconf
, gtkhtml, libglade, scrollkeeper
, webkitgtk
, dbus_glib, enchant, isocodes, libuuid, icu
}:

stdenv.mkDerivation rec {
  name = "xiphos-${version}";  
  version = "4.0.6";

  src = fetchFromGitHub {
    owner = "crosswire";
    repo = "xiphos";
    rev = "${version}";
    sha256 = "02xyy6rxxxaqbjbhdp813f0vp1jpfzqscjdbdc0qcd4yvi3baj5f";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ python intltool docbook2x docbook_xml_dtd_412 libxslt
                  sword clucene_core biblesync gnome_doc_utils libgsf gconf gtkhtml
                  libglade scrollkeeper webkitgtk dbus_glib enchant isocodes libuuid icu ];

  prePatch = ''
    patchShebangs .;
  '';

  preConfigure =  ''
    export CLUCENE_HOME=${clucene_core};
    export SWORD_HOME=${sword};
  '';
  
  configurePhase = ''
    python waf configure --prefix=$out --enable-webkit2
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
