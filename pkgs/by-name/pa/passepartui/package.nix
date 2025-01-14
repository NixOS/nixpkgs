{
  lib,
  fetchFromGitHub,
  gpgme,
  nix-update-script,
  pkg-config,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "passepartui";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "kardwen";
    repo = "passepartui";
    tag = "v${version}";
    hash = "sha256-HOGnbliv9IP7ELW2hlDGzoGdbgn8T3VohHv1YDA8pQY=";
  };

  cargoHash = "sha256-i/DJlxX6KnZeQugah5VseB1jZ1x2WBR780FcrhDBnMs=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ gpgme ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "TUI for pass, the standard unix password manager";
    homepage = "https://github.com/kardwen/passepartui";
    changelog = "https://github.com/kardwen/passepartui/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "passepartui";
  };
}
