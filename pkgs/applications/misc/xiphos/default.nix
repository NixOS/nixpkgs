{ lib, stdenv, fetchFromGitHub, pkg-config
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
  pname = "xiphos";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "crosswire";
    repo = "xiphos";
    rev = version;
    sha256 = "14il9k4i58qbc78hcadw3gqy21sb9q661d75vlj6fwpczbzj7x1a";
  };

  nativeBuildInputs = [ pkg-config wrapGAppsHook wafHook ];
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

  meta = with lib; {
    description = "A GTK Bible study tool";
    longDescription = ''
      Xiphos (formerly known as GnomeSword) is a Bible study tool
      written for Linux, UNIX, and Windows using GTK, offering a rich
      and featureful environment for reading, study, and research using
      modules from The SWORD Project and elsewhere.
    '';
    homepage = "https://www.xiphos.org/";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}
