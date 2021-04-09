{ lib, stdenv
, fetchurl
, meson
, ninja
, pkg-config
, vala
, gettext
, libxml2
, desktop-file-utils
, wrapGAppsHook
, glib
, gtk3
, libgtop
, libdazzle
, gnome3
, tracker
, libhandy
}:

stdenv.mkDerivation rec {
  pname = "gnome-usage";
  version = "3.38.1";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "mMdm4X4VZXEfx0uaJP0u0NX618y0VRlhLdTiFHaO05M=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    libxml2
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    gnome3.adwaita-icon-theme
    gtk3
    libdazzle
    libgtop
    tracker
    libhandy
  ];

  postPatch = ''
    chmod +x build-aux/meson/postinstall.sh
    patchShebangs build-aux/meson/postinstall.sh
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with lib; {
    description = "A nice way to view information about use of system resources, like memory and disk space";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = teams.gnome.members;
  };
}
