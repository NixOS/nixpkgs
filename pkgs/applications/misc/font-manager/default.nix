{ lib
, stdenv
, fetchFromGitHub
, meson
, fetchpatch
, ninja
, gettext
, python3
, pkg-config
, libxml2
, json-glib
, sqlite
, itstool
, yelp-tools
, vala
, gsettings-desktop-schemas
, gtk3
, gnome
, desktop-file-utils
, wrapGAppsHook
, gobject-introspection
, libsoup
, glib-networking
, webkitgtk
}:

stdenv.mkDerivation rec {
  pname = "font-manager";
  version = "0.8.6";

  src = fetchFromGitHub {
    owner = "FontManager";
    repo = "master";
    rev = version;
    sha256 = "0a18rbdy9d0fj0vnsc2rm7xlh17vjqn4kdyrq0ldzlzkb6zbdk2k";
  };

  patches = [
    # Fix some Desktop Settings with GNOME 40.
    # https://github.com/FontManager/font-manager/issues/215
    (fetchpatch {
      url = "https://github.com/FontManager/font-manager/commit/b28f325d7951a66ebf1a2a432ee09fd22048a033.patch";
      sha256 = "dKbrXGb9a4JuG/4x9vprMlh5J17HKJFifRWq9BWp1ow=";
    })
    (fetchpatch {
      url = "https://github.com/FontManager/font-manager/commit/2147204d4c4c6b58161230500186c3a5d4eeb1c1.patch";
      sha256 = "2/PFLwf7h76fIIN4+lyjg/L0KVU1hhRQCfwCAGDpb00=";
    })
    (fetchpatch {
      url = "https://github.com/FontManager/font-manager/commit/3abc541ef8606727c72af7631c021809600336ac.patch";
      sha256 = "rJPnW+7uuFLxTf5tk+Rzo+xkw2+uzU6BkzPXLeR/RGc=";
    })
    (fetchpatch {
      url = "https://github.com/FontManager/font-manager/commit/03a822f0d7b72442cd2ffcc8668da265d3535e0d.patch";
      sha256 = "3Z2UqK5VV2bIwpGd1tA7fivd7ooIuV6CxTJhzgOAkIM=";
    })
  ];

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
    gsettings-desktop-schemas # for font settings
    gtk3
    gnome.adwaita-icon-theme
    libsoup
    glib-networking # for SSL so that Google Fonts can load
    webkitgtk
  ];

  mesonFlags = [
    "-Dreproducible=true" # Do not hardcode build directory…
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
