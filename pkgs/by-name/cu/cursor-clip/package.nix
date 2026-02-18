{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  gtk4,
  libadwaita,
  gtk4-layer-shell,
}:

rustPlatform.buildRustPackage {
  pname = "cursor-clip";
  version = "unstable-2026-02-17";

  src = fetchFromGitHub {
    owner = "Sirulex";
    repo = "cursor-clip";
    rev = "e8015f48782ff91c02cf9d624b8602f10ad5fdaf";
    hash = "sha256-d/7w0yuOsKc41h5z8H9NQ/iOW0fW5E6w8ffcPBt0FuM=";
  };

  cargoHash = "sha256-nIbrapOUcTsHSn1nxEZtzSdDzPzIVuslri7Va94slOE=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    gtk4
    libadwaita
    gtk4-layer-shell
  ];

  meta = {
    description = "GTK4 clipboard manager with dynamic cursor positioning for Wayland";
    longDescription = ''
      A Wayland clipboard manager built with Rust, GTK4, Libadwaita, and
      Wayland Layer Shell. Features a Windows 11-style clipboard history
      interface that appears at the current mouse cursor position.
    '';
    homepage = "https://github.com/Sirulex/cursor-clip";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ salvogiarracca ];
    mainProgram = "cursor-clip";
    platforms = lib.platforms.linux;
  };
}
