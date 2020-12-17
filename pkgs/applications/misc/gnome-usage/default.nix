{ stdenv
, fetchurl
, meson
, ninja
, pkgconfig
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
  version = "3.38.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0mqs39yi2cqwkzlmmgzrszsva5hbdpws6zk4lbi4w2cjzl185mcl";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    libxml2
    meson
    ninja
    pkgconfig
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

  meta = with stdenv.lib; {
    description = "A nice way to view information about use of system resources, like memory and disk space";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = teams.gnome.members;
  };
}
