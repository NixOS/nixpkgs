{
  lib,
  stdenv,
  fetchFromGitHub,

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

  meta = {
    description = "New FlatHub-first app store for GNOME";
    homepage = "https://github.com/kolunmi/bazaar";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ dtomvan ];
    mainProgram = "bazaar";
    platforms = lib.platforms.linux;
  };
})
