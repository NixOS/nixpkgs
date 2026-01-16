{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook4,
  gtk4,
}:

rustPlatform.buildRustPackage {
  pname = "access-launcher";
  version = "0.4.0-unstable-2026-01-08";

  src = fetchFromGitHub {
    owner = "boo15mario";
    repo = "access-launcher";
    rev = "b8e047528c2d91ae6bbc6f31031d1e67908d8f6c";
    hash = "sha256-ScpC6uOZ06UTzyI8Zkp1qsPnG2zllklM5KefkbJdwiA=";
  };

  cargoHash = "sha256-Yri+MWl28/N36MPweGQBOBZSmyC3L89anXe5kwITIxY=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
  ];

  meta = {
    description = "Accessible application launcher";
    homepage = "https://github.com/boo15mario/access-launcher";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "access-launcher";
    platforms = lib.platforms.linux;
  };
}
