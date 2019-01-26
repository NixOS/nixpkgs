{ stdenv
, fetchFromGitLab
, pkgconfig
, intltool
, automake111x
, autoconf
, libtool
, gnome2
, libxslt
, python
}:

let version = "unstable-2018-03-25";

in stdenv.mkDerivation {
  name = "planner-${version}";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "planner";
    rev = "2a2bf11d96a7f5d64f05c9053661baa848e47797";
    sha256 = "1bhh05kkbnhibldc1fc7kv7bwf8aa1vh4q379syqd3jbas8y521g";
  };

  # planner-popup-button.c:81:2: error: 'g_type_class_add_private' is deprecated [-Werror=deprecated-declarations]
  NIX_CFLAGS_COMPILE = "-Wno-error=deprecated-declarations";

  nativeBuildInputs = with gnome2; [
    pkgconfig
    intltool
    automake111x
    autoconf
    libtool
    gnome-common
    gtk-doc
    scrollkeeper
  ];

  buildInputs = with gnome2; [
    GConf
    gtk
    libgnomecanvas
    libgnomeui
    libglade
    libxslt
    python
  ];

  preConfigure = ''./autogen.sh'';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Planner;
    description = "Project management application for GNOME";
    longDescription = ''
      Planner is the GNOME project management tool.
      Its goal is to be an easy-to-use no-nonsense cross-platform
      project management application.

      Planner is a GTK+ application written in C and licensed under the
      GPLv2 or any later version. It can store its data in either xml
      files or in a postgresql database. Projects can also be printed
      to PDF or exported to HTML for easy viewing from any web browser.

      Planner was originally created by Richard Hult and Mikael Hallendal
      at Imendio.
    '';
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ rasendubi amiloradovsky ];
  };
}
