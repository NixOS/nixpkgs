{ stdenv, fetchFromGitHub, meson, ninja, gettext, python3,
  pkgconfig, libxml2, json-glib , sqlite, itstool, librsvg,
  vala, gnome3, desktop-file-utils, wrapGAppsHook, gobject-introspection
}:

stdenv.mkDerivation rec {
  pname = "font-manager";
  version = "0.7.4.2";

  src = fetchFromGitHub {
    owner = "FontManager";
    repo = "master";
    rev = version;
    sha256 = "15814czap0qg2h9nkcn9fg4i4xxa1lgw1vi6h3hi242qfwc7fh3i";
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
    # For setup hook
    gobject-introspection
  ];

  buildInputs = [
    libxml2
    json-glib
    sqlite
    librsvg
    gnome3.gtk
    gnome3.adwaita-icon-theme
  ];

  patches = [ ./correct-post-install.patch ];

  mesonFlags = [
    "-Ddisable_pycompile=true"
  ];

  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
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
    repositories.git = https://github.com/FontManager/master;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
