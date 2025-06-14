{
  lib,
  stdenv,
  fetchFromGitHub,
  writers,

  gtk4,
  libadwaita,
  libdex,
  flatpak,
  appstream,
  libxmlb,
  libglycin,
  libyaml,
  libseccomp,
  lcms2,
  fontconfig,
  gobject-introspection,

  desktop-file-utils,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
}:

let
  # this is just the example from the readme as a PoC
  defaultConfig = writers.writeYAML "bazaar-config.yaml" {
    sections = [
      {
        title = "Section #1";
        subtitle = "The first section";
        description = "These are some of my favorite apps!";
        rows = 3;
        banner = "https://pixls.us/articles/processing-a-nightscape-in-siril/resultat_03_final.jpg";
        banner-fit = "cover";
        appids = [
          "com.usebottles.bottles"
          "io.mgba.mGBA"
          "net.pcsx2.PCSX2"
          "org.blender.Blender"
          "org.desmume.DeSmuME"
          "org.duckstation.DuckStation"
          "org.freecad.FreeCAD"
          "org.gimp.GIMP"
          "org.gnome.Builder"
          "org.gnome.Loupe"
          "org.inkscape.Inkscape"
          "org.kde.krita"
        ];
      }
    ];
  };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "bazaar";
  version = "0-unstable-2025-06-11";

  src = fetchFromGitHub {
    owner = "kolunmi";
    repo = "bazaar";
    rev = "8596403b054c35a355dab58d76fb53b3bb521548";
    hash = "sha256-eYNolx+wvKSUnK1AC4/GY2YWBjvVbqmut0DX36MyC7A=";
  };

  buildInputs = [
    gtk4
    libadwaita
    libdex
    flatpak
    appstream
    libxmlb
    libglycin
    libyaml

    # somehow needed transitively through libglycin
    libseccomp
    lcms2
    fontconfig
    gobject-introspection
  ];

  nativeBuildInputs = [
    desktop-file-utils
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  mesonFlags = [
    (lib.mesonOption "hardcoded_content_config_path" "${defaultConfig}")
  ];

  meta = {
    description = "New FlatHub-first app store for GNOME";
    homepage = "https://github.com/kolunmi/bazaar";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ dtomvan ];
    mainProgram = "bazaar";
    platforms = lib.platforms.linux;
  };
})
