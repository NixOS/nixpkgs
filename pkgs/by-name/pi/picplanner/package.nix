{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
  desktop-file-utils,
  gettext,
  glib,
  gtk4,
  libadwaita,
  libshumate,
  geocode-glib_2,
  libgweather,
  geoclue2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "picplanner";
  version = "0.5.4";

  src = fetchFromGitLab {
    owner = "Zwarf";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    hash = "sha256-pDsm/IZQuXLAOOWDyL6lJ/W4uE7bX6YtfW1do4ELpBA=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    desktop-file-utils
    gettext
  ];

  buildInputs = [
    gtk4
    libadwaita
    libshumate
    geocode-glib_2
    libgweather
    geoclue2
    glib
  ];

  postPatch = ''
    # Install script tries to run host tools not allowed in Nix builds
    sed -i "/meson.add_install_script/d" meson.build
  '';

  preFixup = ''
    # Not handled automatically by wrapGAppsHook4
    glib-compile-schemas "$out/share/gsettings-schemas/$name/glib-2.0/schemas"
  '';

  strictDeps = true;

  meta = with lib; {
    description = "Application for photographers to plan the position of the Sun, Moon and Milky Way";
    homepage = "https://gitlab.com/Zwarf/picplanner";
    license = licenses.gpl3Plus;
    maintainers = [ ];
    platforms = platforms.linux;
    mainProgram = "picplanner";
  };
})
