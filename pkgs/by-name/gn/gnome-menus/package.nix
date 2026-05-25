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
    url = "mirror://gnome/sources/gnome-menus/${lib.versions.majorMinor version}/gnome-menus-${version}.tar.xz";
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

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/gnome-menus";
    description = "Library that implements freedesktops's Desktop Menu Specification in GNOME";
    license = with lib.licenses; [
      gpl2
      lgpl2
    ];
    platforms = lib.platforms.linux;
  };
}
