{
  lib,
  rustPlatform,
  fetchFromGitHub,
  rarezip,
}:

rustPlatform.buildRustPackage {
  pname = "bk_rom_compressor";
  version = "0-unstable-2024-09-08";

  src = fetchFromGitHub {
    owner = "MittenzHugg";
    repo = "bk_rom_compressor";
    rev = "272180b527b01c0023dc2ab02bdfdfd373670906";
    hash = "sha256-lnmnoomJTy8lAjoUjXvkXWFnf9LGtAGcD4WNFTDkiPk=";
    fetchSubmodules = true;
  };

  buildInputs = [
    rarezip
  ];

  cargoHash = "sha256-JxK2S0JTBepT8nTTlBsZlS9+NvL+/rIRPmreX1Kmat4=";

  meta = {
    description = "Banjo-Kazooie rom compressor/decompressor";
    homepage = "https://github.com/MittenzHugg/bk_rom_compressor";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ qubitnano ];
  };
}
