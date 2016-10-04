{ stdenv, fetchFromGitHub, makeWrapper, automake, autoconf, libtool,
  pkgconfig, file, intltool, libxml2, json_glib , sqlite, itstool,
  vala_0_32, gnome3, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  name = "font-manager-${version}";
  version = "2016-06-04";

  src = fetchFromGitHub {
    owner  = "FontManager";
    repo   = "master";
    rev    = "07b47c153494f19ced291c84437349253c5bde4d";
    sha256 = "13pjmvx31fr8fqhl5qwawhawfl7as9c50qshzzig8n5g7vb5v1i0";
    };

  nativeBuildInputs = [
    makeWrapper
    pkgconfig
    automake autoconf libtool
    file
    intltool
    vala_0_32
    gnome3.yelp_tools
    wrapGAppsHook
  ];

  buildInputs = [
    libxml2
    json_glib
    sqlite
    itstool
    gnome3.gtk
    gnome3.gucharmap
    gnome3.libgee
    gnome3.file-roller
  ];

  enableParallelBuilding = true;

  preConfigure = ''
    NOCONFIGURE=true ./autogen.sh
    chmod +x configure;
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
