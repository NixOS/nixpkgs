{
  stdenv,
  lib,
  meson,
  ninja,
  gettext,
  fetchurl,
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
  webkitgtk_4_1,
  gnome,
  adwaita-icon-theme,
  libxml2,
  gsettings-desktop-schemas,
  tinysparql,
}:

stdenv.mkDerivation rec {
  pname = "gnome-notes";
  version = "40.2";

  src = fetchurl {
    url = "mirror://gnome/sources/bijiben/${lib.versions.major version}/bijiben-${version}.tar.xz";
    hash = "sha256-siERvAaVa+81mqzx1u3h5So1sADIgROTZjL4rGztzmc=";
  };

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
    webkitgtk_4_1
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
    teams = [ teams.gnome ];
    platforms = platforms.linux;
  };
}
