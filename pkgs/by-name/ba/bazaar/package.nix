{
  lib,
  stdenv,
  fetchFromGitHub,
  writers,
  wrapGAppsHook4,
  nix-update-script,

  appstream,
  bubblewrap,
  flatpak,
  gnome,
  glycin-loaders,
  gtk4,
  json-glib,
  libadwaita,
  libdex,
  libglycin,
  libsoup_3,
  libxmlb,
  libyaml,

  desktop-file-utils,
  meson,
  ninja,
  pkg-config,

  configFile ? null,
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
  version = "0-unstable-2025-06-21";

  src = fetchFromGitHub {
    owner = "kolunmi";
    repo = "bazaar";
    rev = "d17d0c92a25bbd37a1f4804adbe7c89d71a9f2e8";
    hash = "sha256-9p2E3QD+I+cCRB3MuTQ+E4/Bf9YvU3XftfsoQe7LWT8=";
  };

  buildInputs = [
    appstream
    flatpak
    gnome.gvfs
    gtk4
    json-glib
    libadwaita
    libdex
    (libglycin.overrideAttrs (
      _final: prev: {
        patches = (if prev ? patches then prev.patches else [ ]) ++ [
          # Otherwise the PATH will be cleared and bwrap could not be found
          ./libglycin-no-clearenv.patch
        ];
      }
    ))
    libsoup_3
    libxmlb
    libyaml
  ];

  nativeBuildInputs = [
    desktop-file-utils
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  mesonFlags = [
    (lib.mesonOption "hardcoded_content_config_path" "${finalAttrs.passthru.configFile}")
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : "${lib.makeBinPath [ bubblewrap ]}"
      --prefix XDG_DATA_DIRS : "${glycin-loaders}/share"
    )
  '';

  passthru = {
    updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };
    configFile = if configFile != null then configFile else defaultConfig;
  };

  meta = {
    description = "New FlatHub-first app store for GNOME";
    homepage = "https://github.com/kolunmi/bazaar";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ dtomvan ];
    mainProgram = "bazaar";
    platforms = lib.platforms.linux;
  };
})
