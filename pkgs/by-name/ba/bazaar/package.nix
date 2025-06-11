{
  lib,
  stdenv,
  fetchFromGitHub,
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
}:

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

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : "${lib.makeBinPath [ bubblewrap ]}"
      --prefix XDG_DATA_DIRS : "${glycin-loaders}/share"
    )
  '';

  passthru = {
    updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };
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
