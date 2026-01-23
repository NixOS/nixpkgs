{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  glib,
  pango,
  gdk-pixbuf,
  gtk4,
  libadwaita,
}:

rustPlatform.buildRustPackage rec {
  pname = "lsfg-vk-ui";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "PancakeTAS";
    repo = "lsfg-vk";
    tag = "v${version}";
    hash = "sha256-nIyVOil/gHC+5a+sH3vMlcqVhixjJaGWqXbyoh2Nqyw=";
  };

  cargoHash = "sha256-hIQRS/egIDU5Vu/1KWHtpt4S26h+9GadVr+lBAG2LDg=";

  sourceRoot = "source/ui";

  nativeBuildInputs = [
    pkg-config
    glib
  ];

  buildInputs = [
    pango
    gdk-pixbuf
    gtk4
    libadwaita
  ];

  postInstall = ''
    install -Dm444 $src/ui/rsc/gay.pancake.lsfg-vk-ui.desktop $out/share/applications/gay.pancake.lsfg-vk-ui.desktop
    install -Dm444 $src/ui/rsc/icon.png $out/share/icons/hicolor/256x256/apps/gay.pancake.lsfg-vk-ui.png
  '';

  meta = {
    description = "Graphical configuration interface for lsfg-vk";
    homepage = "https://github.com/PancakeTAS/lsfg-vk/";
    changelog = "https://github.com/PancakeTAS/lsfg-vk/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ pabloaul ];
    mainProgram = "lsfg-vk-ui";
  };
}
