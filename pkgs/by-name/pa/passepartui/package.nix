{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "passepartui";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "kardwen";
    repo = "passepartui";
    rev = "refs/tags/v${version}";
    hash = "sha256-ydX+Rjpfhi0K6f8pzjqWGF0O22gBco6Iot8fXSFNG5c=";
  };

  cargoHash = "sha256-/lgEQ6PmHagt8TlGUV2A95MbV8IQzUwyQ/UkoaGIVHE=";

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
