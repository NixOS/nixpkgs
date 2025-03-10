{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage {
  pname = "pixelpwnr";
  version = "unstable-2023-12-30";

  src = fetchFromGitHub {
    owner = "timvisee";
    repo = "pixelpwnr";
    rev = "38ce0f0c43b5072e35c19048dbe12301614f25ca";
    hash = "sha256-feSrwo8ey9+/gU12QmuBLlqGeWXK23ouZkVYzGPli2E=";
  };

  cargoHash = "sha256-n2lUpzb8yQRBXuT5lF276XAHc95G0WzGny9H4IOO8Ng=";

  meta = with lib; {
    homepage = "https://timvisee.com/projects/pixelpwnr";
    description =
      "Insanely fast pixelflut client for images and animations written in Rust";
    license = licenses.gpl3;
    mainProgram = "pixelpwnr";
  };
}
