{ lib, stdenv, fetchFromGitHub, meson, ninja, gettext, python3,
  pkg-config, libxml2, json-glib , sqlite, itstool, librsvg, yelp-tools,
  vala, gtk3, gnome3, desktop-file-utils, wrapGAppsHook, gobject-introspection
}:

stdenv.mkDerivation rec {
  pname = "font-manager";
  version = "0.7.9";

  src = fetchFromGitHub {
    owner = "FontManager";
    repo = "master";
    rev = version;
    sha256 = "1nc0i824v2szz0j9a5rwl8gygih15xbxnxpnx9d3wr0yq9057q6q";
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
    librsvg
    gtk3
    gnome3.adwaita-icon-theme
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
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
