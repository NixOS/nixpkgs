{ stdenv, fetchFromGitHub, automake, autoconf, libtool,
  pkgconfig, file, intltool, libxml2, json-glib , sqlite, itstool,
  librsvg, vala, gnome3, wrapGAppsHook, gobjectIntrospection
}:

stdenv.mkDerivation rec {
  name = "font-manager-${version}";
  version = "0.7.3.1";

  src = fetchFromGitHub {
    owner = "FontManager";
    repo = "master";
    rev = version;
    sha256 = "0i65br0bk3r6x8wcl8jhc0v0agl0k6fy5g60ss1bnw4md7ldpgyi";
    };

  nativeBuildInputs = [
    pkgconfig
    automake autoconf libtool
    file
    intltool
    itstool
    vala
    gnome3.yelp-tools
    wrapGAppsHook
    # For setup hook
    gobjectIntrospection
  ];

  buildInputs = [
    libxml2
    json-glib
    sqlite
    librsvg
    gnome3.gtk
    gnome3.libgee
    gnome3.defaultIconTheme
  ];

  enableParallelBuilding = true;

  preConfigure = ''
    NOCONFIGURE=true ./autogen.sh
    substituteInPlace configure --replace "/usr/bin/file" "${file}/bin/file"
  '';

  configureFlags = [
    "--with-file-roller"
    "--disable-pycompile"
  ];

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
