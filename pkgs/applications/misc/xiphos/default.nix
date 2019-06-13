{ stdenv, fetchFromGitHub, pkgconfig
, python
, intltool
, docbook2x, docbook_xml_dtd_412, libxslt
, sword, clucene_core, biblesync
, gnome-doc-utils
, libgsf, gconf
, gtkhtml, libglade, scrollkeeper
, webkitgtk
, dbus-glib, enchant, isocodes, libuuid, icu
, wrapGAppsHook
, wafHook
}:

stdenv.mkDerivation rec {
  name = "xiphos-${version}";
  version = "4.0.7";

  src = fetchFromGitHub {
    owner = "crosswire";
    repo = "xiphos";
    rev = "${version}";
    sha256 = "1vwf1ps6nrajxl1qbs6v1cgykmq5wn4j09j10gbcd3b2nvrprf3g";
  };

  nativeBuildInputs = [ pkgconfig wrapGAppsHook wafHook ];
  buildInputs = [ python intltool docbook2x docbook_xml_dtd_412 libxslt
                  sword clucene_core biblesync gnome-doc-utils libgsf gconf gtkhtml
                  libglade scrollkeeper webkitgtk dbus-glib enchant isocodes libuuid icu ];

  prePatch = ''
    patchShebangs .;
  '';

  preConfigure =  ''
    export CLUCENE_HOME=${clucene_core};
    export SWORD_HOME=${sword};
  '';

  wafConfigureFlags = [ "--enable-webkit2" ];

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
