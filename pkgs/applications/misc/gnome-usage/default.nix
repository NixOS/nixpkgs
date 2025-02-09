{ stdenv
, lib
, fetchurl
, meson
, ninja
, pkg-config
, vala
, gettext
, libxml2
, desktop-file-utils
, wrapGAppsHook4
, glib
, gtk4
, libadwaita
, libgee
, libgtop
, gnome
, tracker
}:

stdenv.mkDerivation rec {
  pname = "gnome-usage";
  version = "45.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "5nfE/iwBSXqE/x4RV+kTHp+ZmfGnjTUjSvHXfYJ18pQ=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    libxml2
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    libgee
    libgtop
    tracker
  ];

  postPatch = ''
    chmod +x build-aux/meson/postinstall.sh
    patchShebangs build-aux/meson/postinstall.sh
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
    };
  };

  meta = with lib; {
    description = "A nice way to view information about use of system resources, like memory and disk space";
    homepage = "https://gitlab.gnome.org/GNOME/gnome-usage";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.gnome.members;
  };
}
