{
  lib,
  mkHyprlandPlugin,
  fetchFromGitHub,
  cmake,
  glib,
  gtk4,
  gtk4-layer-shell,
  hyprland,
  libadwaita,
  lua5_4,
  python3,
  wayland,
}:

mkHyprlandPlugin (finalAttrs: {
  pluginName = "hymission";
  version = "0.12.1-unstable-2026-11-15";

  src = fetchFromGitHub {
    owner = "gfhdhytghd";
    repo = "hymission";
    rev = "4fe476c29203b25b891e22198a330d8acab76d8f";
    hash = "sha256-caGhCn1gI22igIvjLl6Qs67R4Ej2feGpRQYXEdTsTmo=";
  };

  nativeBuildInputs = [
    cmake
    python3
  ];

  buildInputs = [
    glib
    gtk4
    gtk4-layer-shell
    libadwaita
    lua5_4
    wayland
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.finalPackage.doCheck)
    (lib.cmakeFeature "HYPRLAND_TEST_EXECUTABLE" "${hyprland}/bin/.Hyprland-wrapped")
  ];

  doCheck = true;

  meta = {
    description = "Mission Control overview for Hyprland";
    homepage = "https://github.com/gfhdhytghd/hymission";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ cRolandoJr ];
    platforms = hyprland.meta.platforms;
  };
})
