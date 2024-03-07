{ lib
, rustPlatform
, fetchFromGitHub
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "elf-info";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "kevin-lesenechal";
    repo = "elf-info";
    rev = "v${version}";
    hash = "sha256-wbFVuoarOoxV9FqmuHJ9eZlG4rRqy1rsnuqbGorC2Rk=";
  };

  cargoHash = "sha256-r4GcJhQn9x5c2hbL+813mS3HbIg8OwNDsMg/fHQoL9Y=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Inspect and dissect an ELF file with pretty formatting";
    homepage = "https://github.com/kevin-lesenechal/elf-info";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ viperML ];
    mainProgram = "elf";
  };
}
