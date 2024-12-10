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
  version = "46.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    hash = "sha256-ht9YoVlbIVN0aRq0S/wWE7Sf28p3CEI6PVZY3NOgFe0=";
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

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/gnote";
    description = "A note taking application";
    mainProgram = "gnote";
    maintainers = with maintainers; [ jfvillablanca ];
    license = licenses.gpl3Only;
    platforms = platforms.linux;
  };
}
