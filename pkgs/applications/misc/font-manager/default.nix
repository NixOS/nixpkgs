{ stdenv, fetchFromGitHub, automake, autoconf, libtool,
  pkgconfig, file, libxml2, json-glib , sqlite, itstool,
  librsvg, vala, gnome3, wrapGAppsHook, gobject-introspection,
  which
}:

stdenv.mkDerivation rec {
  name = "font-manager-${version}";
  version = "0.7.4.1";

  src = fetchFromGitHub {
    owner = "FontManager";
    repo = "master";
    rev = version;
    sha256 = "1zy419zzc95h4gxvl88acqjbwlnmwybj23rx3vkc62j3v3w4nlay";
  };

  nativeBuildInputs = [
    pkgconfig
    automake autoconf libtool
    file
    which
    itstool
    vala
    gnome3.yelp-tools
    wrapGAppsHook
    # For setup hook
    gobject-introspection
  ];

  buildInputs = [
    libxml2
    json-glib
    sqlite
    librsvg
    gnome3.gtk
    gnome3.defaultIconTheme
  ];

  enableParallelBuilding = true;

  preConfigure = ''
    NOCONFIGURE=true ./autogen.sh
    substituteInPlace configure --replace "/usr/bin/file" "${file}/bin/file"
  '';

  configureFlags = [
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
