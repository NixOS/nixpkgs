{ lib
, stdenv
, fetchurl
, desktop-file-utils
, gettext
, gspell
, gtkmm3
, itstool
, libsecret
, libuuid
, libxml2
, libxslt
, meson
, ninja
, pkg-config
, wrapGAppsHook
, gnome
}:

stdenv.mkDerivation rec {
  pname = "gnote";
  version = "44.1";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    hash = "sha256-aWelUGgiMguuGcHrC8dFFmRPnp61TtwslCU+rhDHYE0=";
  };

  buildInputs = [
    gspell
    gtkmm3
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
    wrapGAppsHook
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
