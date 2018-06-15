{ stdenv, fetchFromGitHub, automake, autoconf, libtool,
  pkgconfig, file, intltool, libxml2, json-glib , sqlite, itstool,
  librsvg, vala_0_34, gnome3, wrapGAppsHook, gobjectIntrospection
}:

stdenv.mkDerivation rec {
  name = "font-manager-${version}";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner  = "FontManager";
    repo   = "master";
    rev    = version;
    sha256 = "0qwi1mn2sc2q5cs28rga8i3cn34ylybs949vjnh97dl2rvlc0x06";
    };

  nativeBuildInputs = [
    pkgconfig
    automake autoconf libtool
    file
    intltool
    vala_0_34
    gnome3.yelp-tools
    wrapGAppsHook
    # For setup hook
    gobjectIntrospection
  ];

  buildInputs = [
    libxml2
    json-glib
    sqlite
    itstool
    librsvg
    gnome3.gtk
    gnome3.gucharmap
    gnome3.libgee
    gnome3.file-roller
    gnome3.defaultIconTheme
  ];

  enableParallelBuilding = true;

  preConfigure = ''
    NOCONFIGURE=true ./autogen.sh
    substituteInPlace configure --replace "/usr/bin/file" "${file}/bin/file"
  '';

  configureFlags = "--disable-pycompile";

  meta = {
    homepage = https://fontmanager.github.io/;
    description = "Simple font management for GTK+ desktop environments";
    longDescription = ''
      Font Manager is intended to provide a way for average users to
      easily manage desktop fonts, without having to resort to command
      line tools or editing configuration files by hand. While designed
      primarily with the Gnome Desktop Environment in mind, it should
      work well with other Gtk+ desktop environments.

      Font Manager is NOT a professional-grade font management solution.
    '';
    license = stdenv.lib.licenses.gpl3;
    repositories.git = https://github.com/FontManager/master;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
