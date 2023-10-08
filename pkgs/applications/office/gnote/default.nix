{ lib
, stdenv
, fetchurl
, cmake
, desktop-file-utils
, gettext
, glibmm_2_68
, gspell
, gtkmm4
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
  version = "45.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    hash = "sha256-XRb9h9FA7HL7s1ewVp2u+4Io4HgUcBVG5r3mVyGTwko=";
  };

  buildInputs = [
    gspell
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
    cmake
    glibmm_2_68
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
