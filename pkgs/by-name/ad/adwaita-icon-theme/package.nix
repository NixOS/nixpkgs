{ lib
, stdenv
, fetchurl
, meson
, ninja
, pkg-config
, gnome
, gtk3
, gdk-pixbuf
, librsvg
, hicolor-icon-theme
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "adwaita-icon-theme";
  version = "46.2";

  src = fetchurl {
    url = "mirror://gnome/sources/adwaita-icon-theme/${lib.versions.major finalAttrs.version}/adwaita-icon-theme-${finalAttrs.version}.tar.xz";
    hash = "sha256-vrEmuUKTObp2LggY1ec7LEb0RJdb+AB2Nm6uLQ+Wtcs=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gtk3
  ];

  buildInputs = [
    gdk-pixbuf
    librsvg
  ];

  propagatedBuildInputs = [
    # For convenience, we can specify adwaita-icon-theme only in packages
    hicolor-icon-theme
  ];

  dontDropIconThemeCache = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "adwaita-icon-theme";
    };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/adwaita-icon-theme";
    platforms = with platforms; linux ++ darwin;
    maintainers = teams.gnome.members;
    license = licenses.cc-by-sa-30;
  };
})
