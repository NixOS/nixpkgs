{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  gnome,
  gtk3,
  gdk-pixbuf,
  librsvg,
  hicolor-icon-theme,
}:

stdenv.mkDerivation rec {
  pname = "adwaita-icon-theme";
  version = "49.0";

  src = fetchurl {
    url = "mirror://gnome/sources/adwaita-icon-theme/${lib.versions.major version}/adwaita-icon-theme-${version}.tar.xz";
    hash = "sha256-ZRZkYdGyeKqUL1mqjQ/M8RCNccZfNyxiZuFyRJeRdVw=";
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

  postPatch = ''
    # Postpone these changes for now, please discuss in https://github.com/NixOS/nixpkgs/pull/316416
    substituteInPlace index.theme \
      --replace-fail "Hidden=true" "" \
      --replace-fail "Inherits=AdwaitaLegacy,hicolor" "Inherits=hicolor"
  '';

  dontDropIconThemeCache = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "adwaita-icon-theme";
    };
  };

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/adwaita-icon-theme";
    changelog = "https://gitlab.gnome.org/GNOME/adwaita-icon-theme/-/blob/${version}/NEWS?ref_type=tags";
    platforms = with lib.platforms; linux ++ darwin;
    teams = [ lib.teams.gnome ];
    license = lib.licenses.cc-by-sa-30;
  };
}
