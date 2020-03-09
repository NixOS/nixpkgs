{ stdenv
, fetchFromGitLab
, pkgconfig
, intltool
, automake111x
, autoconf
, libtool
, gnome2
, libxslt
, python2
}:

let version = "unstable-2019-02-13";

in stdenv.mkDerivation {
  pname = "planner";
  inherit version;

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "planner";
    rev = "76d31defae4979aa51dd37e8888f61e9a6a51367";
    sha256 = "0lbch4drg6005216hgcys93rq92p7zd20968x0gk254kckd9ag5w";
  };

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
    python2.pkgs.pygtk
  ];

  # glib-2.62 deprecations
  NIX_CFLAGS_COMPILE = "-DGLIB_DISABLE_DEPRECATION_WARNINGS";

  preConfigure = ''./autogen.sh'';
  configureFlags = [
    "--enable-python"
    "--enable-python-plugin"
    ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Planner;
    description = "Project management application for GNOME";
    longDescription = ''
      Planner is the GNOME project management tool.
      Its goal is to be an easy-to-use no-nonsense cross-platform
      project management application.

      Planner is a GTK application written in C and licensed under the
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
