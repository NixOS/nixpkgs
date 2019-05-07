{ stdenv, fetchFromGitHub, meson, ninja, gettext, python3, fetchpatch,
  pkgconfig, libxml2, json-glib , sqlite, itstool, librsvg,
  vala, gtk3, gnome3, desktop-file-utils, wrapGAppsHook, gobject-introspection
}:

stdenv.mkDerivation rec {
  pname = "font-manager";
  version = "0.7.5";

  src = fetchFromGitHub {
    owner = "FontManager";
    repo = "master";
    rev = version;
    sha256 = "16hma8rrkam6ngn5vbdaryn31vdixvii6920g9z928gylz9xkd3g";
  };

  nativeBuildInputs = [
    pkgconfig
    meson
    ninja
    gettext
    python3
    itstool
    desktop-file-utils
    vala
    gnome3.yelp-tools
    wrapGAppsHook
    # For https://github.com/FontManager/master/blob/master/lib/unicode/meson.build
    gobject-introspection
  ];

  buildInputs = [
    libxml2
    json-glib
    sqlite
    librsvg
    gtk3
    gnome3.adwaita-icon-theme
  ];

  mesonFlags = [
    "-Ddisable_pycompile=true"
  ];

  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
  '';

  meta = with stdenv.lib; {
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
    license = licenses.gpl3;
    repositories.git = https://github.com/FontManager/master;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
