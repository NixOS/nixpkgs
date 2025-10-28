{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
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
  gtk4,
  adwaita-icon-theme,
  libarchive,
  desktop-file-utils,
  nix-update-script,
  wrapGAppsHook4,
  gobject-introspection,
  # withWebkit enables the "webkit" feature, also known as Google Fonts
  withWebkit ? true,
  glib-networking,
  libsoup_3,
  webkitgtk_6_0,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "font-manager";
  version = "0.9.4";

  src = fetchFromGitHub {
    owner = "FontManager";
    repo = "font-manager";
    tag = finalAttrs.version;
    hash = "sha256-hggRvwMy/D2jc98CQPc7GChTV9+zYbYHPMENf/8Uq9s=";
  };

  patches = [
    # TODO: drop this patch when updating beyond version 0.9.4
    (fetchpatch {
      name = "fix-reproducible-build-issue.patch";
      url = "https://github.com/FontManager/font-manager/commit/cc0c148d90741e39615e3380d283f684a052dd94.patch";
      hash = "sha256-bRn+jVjBu6ZqmQCErgcqxv6OyFa4hkPYB5bvK7rEibA=";
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
    wrapGAppsHook4
    # For https://github.com/FontManager/master/blob/master/lib/unicode/meson.build
    gobject-introspection
  ];

  buildInputs = [
    libxml2
    json-glib
    sqlite
    gsettings-desktop-schemas # for font settings
    gtk4
    adwaita-icon-theme
    libarchive
  ]
  ++ lib.optionals withWebkit [
    glib-networking # for SSL so that Google Fonts can load
    libsoup_3
    webkitgtk_6_0
  ];

  mesonFlags = [
    "-Dreproducible=true" # Do not hardcode build directory…
    (lib.mesonBool "webkit" withWebkit)
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://fontmanager.github.io/";
    changelog = "https://github.com/FontManager/font-manager/raw/refs/tags/${finalAttrs.version}/CHANGELOG";
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
})
