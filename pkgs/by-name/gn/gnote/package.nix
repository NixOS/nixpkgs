{
  lib,
  stdenv,
  fetchurl,
  desktop-file-utils,
  gettext,
  gtkmm4,
  itstool,
  libadwaita,
  libsecret,
  libuuid,
  libxml2,
  libxslt,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
  gnome,
}:

stdenv.mkDerivation rec {
  pname = "gnote";
  version = "49.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnote/${lib.versions.major version}/gnote-${version}.tar.xz";
    hash = "sha256-lC8CsXIFff4HbdBNDwNlLqafNjg3Lsbrn8p3CBYEp7U=";
  };

  buildInputs = [
    gtkmm4
    libadwaita
    libsecret
    libuuid
    libxml2
    libxslt
  ];

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    itstool
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
    };
  };

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/gnote";
    description = "Note taking application";
    mainProgram = "gnote";
    maintainers = with lib.maintainers; [ jfvillablanca ];
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
  };
}
