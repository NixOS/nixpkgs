{ stdenv, fetchFromGitHub, makeWrapper, automake, autoconf, libtool,
  pkgconfig, file, intltool, libxml2, json_glib , sqlite, itstool,
  vala, gnome3
}:

stdenv.mkDerivation rec {
  name = "font-manager-${version}";
  version = "git-2016-03-02";

  src = fetchFromGitHub {
    owner  = "FontManager";
    repo   = "master";
    rev    = "743fb83558c86bfbbec898106072f84422c175d6";
    sha256 = "1sakss6irfr3d8k39x1rf72fmnpq47akhyrv3g45a3l6v6xfqp3k";
    };

  enableParallelBuilding = true;

  buildInputs = [
    makeWrapper
    pkgconfig
    automake autoconf libtool
    file
    intltool
    libxml2
    json_glib
    sqlite
    itstool
    vala
    gnome3.gtk
    gnome3.gucharmap
    gnome3.libgee
    gnome3.file-roller
    gnome3.yelp_tools
  ];

  preConfigure = ''
    NOCONFIGURE=true ./autogen.sh
    chmod +x configure;
    substituteInPlace configure --replace "/usr/bin/file" "${file}/bin/file"
  '';

  configureFlags = "--disable-pycompile";

  preFixup = ''
    for prog in "$out/bin/"* "$out/libexec/font-manager/"*; do
      wrapProgram "$prog" \
        --prefix XDG_DATA_DIRS : "$out/share:$GSETTINGS_SCHEMAS_PATH"
    done
  '';

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
    maintainers = [ stdenv.lib.maintainers.romildo ];
    repositories.git = https://github.com/FontManager/master;
    platforms = stdenv.lib.platforms.unix;
  };
}
