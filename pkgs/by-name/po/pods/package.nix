{
  lib,
  stdenv,
  fetchFromGitHub,
  cargo,
  desktop-file-utils,
  glib,
  gtk4,
  meson,
  ninja,
  pkg-config,
  rustPlatform,
  rustc,
  wrapGAppsHook4,
  gtksourceview5,
  libadwaita,
  libpanel,
  vte-gtk4,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "pods";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "marhkb";
    repo = "pods";
    tag = "v${version}";
    hash = "sha256-m+0XjxY0nDAJbVX3r/Jfg+G+RU8Q51e0ZXxkdH69SiQ=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-ssLiGYBz8fh0oci/pVaeEEIruA691tdEOUyEFssNUXU=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    glib
    gtk4
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    cargo
    rustc
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    gtksourceview5
    libadwaita
    libpanel
    vte-gtk4
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Podman desktop application";
    homepage = "https://github.com/marhkb/pods";
    changelog = "https://github.com/marhkb/pods/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ figsoda ];
    platforms = lib.platforms.linux;
    mainProgram = "pods";
  };
}
