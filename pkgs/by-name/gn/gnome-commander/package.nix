{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  flex,
  itstool,
  rustPlatform,
  rustc,
  cargo,
  wrapGAppsHook4,
  desktop-file-utils,
  exiv2,
  libgsf,
  taglib,
  poppler,
  samba,
  gtest,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-commander";
  version = "1.18.1-unstable-2024-10-18";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "gnome-commander";
    rev = "28dadb1ef9342bb1a5f9a65b1a5bf3bd80e3d30a";
    hash = "sha256-DxsZJht+PD3vY5vc1vzpRD8FHBPKcjK4qfke5nhvHS0=";
  };

  # hard-coded schema paths
  postPatch = ''
    substituteInPlace src/gnome-cmd-data.cc plugins/fileroller/file-roller-plugin.cc \
      --replace-fail \
        '/share/glib-2.0/schemas' \
        '/share/gsettings-schemas/${finalAttrs.finalPackage.name}/glib-2.0/schemas'
  '';

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit (finalAttrs) pname version src;
    hash = "sha256-Nx/e2H9NxCTj62xVDlKTpPdjlxAx2YAcQJh1kHByrd4=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    flex
    itstool
    rustPlatform.cargoSetupHook
    rustc
    cargo
    wrapGAppsHook4
    desktop-file-utils
  ];

  buildInputs = [
    exiv2
    libgsf
    taglib
    poppler
    samba
    gtest
  ];

  meta = {
    description = "Fast and powerful twin-panel file manager for the Linux desktop";
    homepage = "https://gcmd.github.io";
    license = lib.licenses.gpl2Plus;
    mainProgram = "gnome-commander";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.linux;
  };
})
