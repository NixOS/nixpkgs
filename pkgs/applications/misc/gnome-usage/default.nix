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
}:

stdenv.mkDerivation rec {
  pname = "gnome-usage";
  version = "3.32.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0bgszckddfpd3czyb9fddx4pgv5yv44sxc45dfk2kgqyy169gjih";
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
    maintainers = gnome3.maintainers;
  };
}
