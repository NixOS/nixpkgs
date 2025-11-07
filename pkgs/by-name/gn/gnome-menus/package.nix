{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gettext,
  glib,
  gobject-introspection,
  gnome,
}:

stdenv.mkDerivation rec {
  pname = "gnome-menus";
  version = "3.38.1";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "EZipHNvc+yMt+U5x71QnYX0mAp4ye+P4YMOwkhxEgRg=";
  };

  makeFlags = [
    "INTROSPECTION_GIRDIR=${placeholder "out"}/share/gir-1.0/"
    "INTROSPECTION_TYPELIBDIR=${placeholder "out"}/lib/girepository-1.0"
  ];

  nativeBuildInputs = [
    pkg-config
    gettext
    gobject-introspection
  ];
  buildInputs = [ glib ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "none";
    };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/gnome-menus";
    description = "Library that implements freedesktops's Desktop Menu Specification in GNOME";
    license = with licenses; [
      gpl2
      lgpl2
    ];
    platforms = platforms.linux;
  };
}
