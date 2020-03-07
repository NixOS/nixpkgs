{ stdenv
, fetchurl
, appstream-glib
, desktop-file-utils
, gettext
, glib
, gnome3
, gtk3
, gusb
, libcanberra-gtk3
, libgudev
, meson
, ninja
, pkgconfig
, wrapGAppsHook
, polkit
, udisks
}:

stdenv.mkDerivation rec {
  pname = "gnome-multi-writer";
  version = "3.32.1";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1apdd8yi12zagf82k376a9wmdm27wzwdxpm2wf2pnwkaf786rmdw";
  };

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    gettext
    meson
    ninja
    pkgconfig
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    gtk3
    gusb
    libcanberra-gtk3
    libgudev
    polkit
    udisks
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "Tool for writing an ISO file to multiple USB devices at once";
    homepage = https://wiki.gnome.org/Apps/MultiWriter;
    license = licenses.gpl2Plus;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
