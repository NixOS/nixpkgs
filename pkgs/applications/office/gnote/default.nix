{ lib
, stdenv
, fetchurl
, desktop-file-utils
, gettext
, gtkmm4
, itstool
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
  version = "45.1";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    hash = "sha256-nuwn+MsKENL9uRSkUei4QYwmDni/BzYHgaeKXkGM+UE=";
  };

  buildInputs = [
    gtkmm4
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
