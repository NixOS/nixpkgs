{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  gettext,
  python3,
  pkg-config,
  libxml2,
  json-glib,
  sqlite,
  itstool,
  yelp-tools,
  vala,
  gsettings-desktop-schemas,
  gtk3,
  gnome,
  desktop-file-utils,
  fetchpatch2,
  wrapGAppsHook3,
  gobject-introspection,
  # withWebkit enables the "webkit" feature, also known as Google Fonts
  withWebkit ? true,
  glib-networking,
  libsoup,
  webkitgtk,
}:

stdenv.mkDerivation rec {
  pname = "font-manager";
  version = "0.8.8";

  src = fetchFromGitHub {
    owner = "FontManager";
    repo = "font-manager";
    rev = version;
    hash = "sha256-M13Q9d2cKhc0tudkvw0zgqPAFTlmXwK+LltXeuDPWxo=";
  };

  patches = [
    # see https://github.com/FontManager/font-manager/issues/355
    # should be removed on next release
    (fetchpatch2 {
      name = "fix-build-with-newer-vala.patch";
      url = "https://github.com/FontManager/font-manager/commit/600f498946c3904064b4e4fdf96e5841f6a827e4.patch";
      hash = "sha256-DC9+pvG88t+PPdGQ2oemeEYK9PaD0C2yWBYYCh4Wn9g=";
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
    wrapGAppsHook3
    # For https://github.com/FontManager/master/blob/master/lib/unicode/meson.build
    gobject-introspection
  ];

  buildInputs =
    [
      libxml2
      json-glib
      sqlite
      gsettings-desktop-schemas # for font settings
      gtk3
      gnome.adwaita-icon-theme
    ]
    ++ lib.optionals withWebkit [
      glib-networking # for SSL so that Google Fonts can load
      libsoup
      webkitgtk
    ];

  mesonFlags = [
    "-Dreproducible=true" # Do not hardcode build directory…
    (lib.mesonBool "webkit" withWebkit)
  ];

  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
  '';

  meta = with lib; {
    homepage = "https://fontmanager.github.io/";
    description = "Simple font management for GTK desktop environments";
    mainProgram = "font-manager";
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
