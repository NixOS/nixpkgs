{ stdenv
, lib
, fetchurl
, wrapGAppsNoGuiHook
, meson
, ninja
, pkg-config
, gnome
, gdk-pixbuf
, glib
, libarchive
, librsvg
, libxml2
}:

stdenv.mkDerivation rec {
  pname = "gnome-epub-thumbnailer";
  version = "1.8";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-epub-thumbnailer/${lib.versions.majorMinor version}/gnome-epub-thumbnailer-${version}.tar.xz";
    sha256 = "sha256-+QYZ1YxpkC8u/1e58AQrRzeGEIP0dZIaMQ/sxhL8oBc=";
  };

  nativeBuildInputs = [
    wrapGAppsNoGuiHook
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    gdk-pixbuf
    glib
    libarchive
    librsvg
    libxml2
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-epub-thumbnailer";
    };
  };

  meta = with lib; {
    description = "Thumbnailer for EPub and MOBI books";
    homepage = "https://gitlab.gnome.org/GNOME/gnome-epub-thumbnailer";
    license = licenses.gpl2Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
