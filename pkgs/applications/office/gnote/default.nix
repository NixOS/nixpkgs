{ lib
, stdenv
, fetchurl
, desktop-file-utils
, gettext
, gtkmm4
, itstool
, libadwaita
, libsecret
, libuuid
, libxml2
, libxslt
, meson
, ninja
, pkg-config
, wrapGAppsHook4
, gnome
}:

stdenv.mkDerivation rec {
  pname = "gnote";
  version = "46.alpha";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    hash = "sha256-D1z1cq9CpB1TTKd+a6MxVp8hATHKscm9B4J7NSp13yY=";
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
    homepage = "https://wiki.gnome.org/Apps/Gnote";
    description = "A note taking application";
    maintainers = with maintainers; [ jfvillablanca ];
    license = licenses.gpl3Only;
    platforms = platforms.linux;
  };
}
