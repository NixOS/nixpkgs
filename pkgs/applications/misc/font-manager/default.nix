{ lib, stdenv, fetchFromGitHub, meson, ninja, gettext, python3,
  pkg-config, libxml2, json-glib , sqlite, itstool, yelp-tools,
  vala, gtk3, gnome3, desktop-file-utils, wrapGAppsHook, gobject-introspection,
  libsoup, webkitgtk
}:

stdenv.mkDerivation rec {
  pname = "font-manager";
  version = "0.8.5-1";

  src = fetchFromGitHub {
    owner = "FontManager";
    repo = "master";
    rev = version;
    sha256 = "1p0hfnf06892hn25a6zv8fnhbh4ln11nn2fv1vjqs63rr59fprbk";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    gettext
    python3
    itstool
    desktop-file-utils
    vala
    yelp-tools
    wrapGAppsHook
    # For https://github.com/FontManager/master/blob/master/lib/unicode/meson.build
    gobject-introspection
  ];

  buildInputs = [
    libxml2
    json-glib
    sqlite
    gtk3
    gnome3.adwaita-icon-theme
    libsoup
    webkitgtk
  ];

  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
  '';

  meta = with lib; {
    homepage = "https://fontmanager.github.io/";
    description = "Simple font management for GTK desktop environments";
    longDescription = ''
      Font Manager is intended to provide a way for average users to
      easily manage desktop fonts, without having to resort to command
      line tools or editing configuration files by hand. While designed
      primarily with the Gnome Desktop Environment in mind, it should
      work well with other GTK desktop environments.

      Font Manager is NOT a professional-grade font management solution.
    '';
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
