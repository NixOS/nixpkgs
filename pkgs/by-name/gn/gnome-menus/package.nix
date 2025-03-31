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
  version = "3.36.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "07xvaf8s0fiv0035nk8zpzymn5www76w2a1vflrgqmp9plw8yd6r";
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
