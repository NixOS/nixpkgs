{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "river-bsp-layout";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "areif-dev";
    repo = "river-bsp-layout";
    rev = "v${version}";
    hash = "sha256-/R9v3NGsSG4JJtdk0sJX7ahRolRmJMwMP48JRmLffXc=";
  };

  cargoHash = "sha256-kfeRGT/qgZRPfXl03JYRF1CVPIIiGPIdxLORiA6QWu4=";

  meta = {
    homepage = "https://github.com/areif-dev/river-bsp-layout";
    description = "Binary space partition / grid layout manager for River WM";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ areif-dev ];
    mainProgram = "river-bsp-layout";
    platforms = lib.platforms.linux;
  };
}
