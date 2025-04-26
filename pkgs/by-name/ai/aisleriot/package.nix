{
  stdenv,
  lib,
  fetchurl,
  pkg-config,
  itstool,
  gtk3,
  wrapGAppsHook3,
  meson,
  librsvg,
  libxml2,
  desktop-file-utils,
  guile,
  libcanberra-gtk3,
  ninja,
  yelp-tools,
  gnome,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "aisleriot";
  version = "3.22.35";

  src = fetchurl {
    url = "mirror://gnome/sources/aisleriot/${lib.versions.majorMinor finalAttrs.version}/aisleriot-${finalAttrs.version}.tar.xz";
    hash = "sha256-AeYEzXAJo2wMXxVCSpBORvg2LDBrpfa8cfrIpedGO/A=";
  };

  nativeBuildInputs = [
    wrapGAppsHook3
    meson
    ninja
    pkg-config
    itstool
    libxml2
    desktop-file-utils
    yelp-tools
  ];

  buildInputs = [
    gtk3
    librsvg
    guile
    libcanberra-gtk3
  ];

  prePatch = ''
    patchShebangs cards/meson_svgz.sh
    patchShebangs data/meson_desktopfile.py
    patchShebangs data/icons/meson_updateiconcache.py
    patchShebangs src/lib/meson_compileschemas.py
  '';

  mesonFlags = [ "-Dtheme_kde=false" ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "aisleriot";
    };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/aisleriot";
    description = "Collection of patience games written in guile scheme";
    mainProgram = "sol";
    teams = [ teams.gnome ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
})
