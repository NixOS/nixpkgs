{
  stdenv,
  lib,
  meson,
  ninja,
  gettext,
  fetchurl,
  fetchpatch,
  pkg-config,
  wrapGAppsHook3,
  itstool,
  desktop-file-utils,
  python3,
  glib,
  gtk3,
  evolution-data-server,
  gnome-online-accounts,
  json-glib,
  libuuid,
  curl,
  libhandy,
  webkitgtk_4_0,
  gnome,
  adwaita-icon-theme,
  libxml2,
  gsettings-desktop-schemas,
  tinysparql,
}:

stdenv.mkDerivation rec {
  pname = "gnome-notes";
  version = "40.1";

  src = fetchurl {
    url = "mirror://gnome/sources/bijiben/${lib.versions.major version}/bijiben-${version}.tar.xz";
    hash = "sha256-BaBvsGbpgC9fJKtnsNL3FFGGY2O6Pjn593X9SadYe78=";
  };

  patches = [
    # Fix build with meson 0.61
    # data/appdata/meson.build:3:5: ERROR: Function does not take positional arguments.
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-notes/-/commit/994af76ce5144062d55d141129bf6bf5fab002ee.patch";
      hash = "sha256-z7dPOLZzaqvdqUIDy6+V3dKossRbG0EDjBu2oJCF6b4=";
    })
  ];

  doCheck = true;

  postPatch = ''
    chmod +x build-aux/meson_post_install.py
    patchShebangs build-aux/meson_post_install.py
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    itstool
    libxml2
    desktop-file-utils
    python3
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    gtk3
    json-glib
    libuuid
    curl
    libhandy
    webkitgtk_4_0
    tinysparql
    gnome-online-accounts
    gsettings-desktop-schemas
    evolution-data-server
    adwaita-icon-theme
  ];

  mesonFlags = [ "-Dupdate_mimedb=false" ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "bijiben";
      attrPath = "gnome-notes";
    };
  };

  meta = with lib; {
    description = "Note editor designed to remain simple to use";
    mainProgram = "bijiben";
    homepage = "https://gitlab.gnome.org/GNOME/gnome-notes";
    license = licenses.gpl3;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
