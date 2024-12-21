{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "passepartui";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "kardwen";
    repo = "passepartui";
    rev = "refs/tags/v${version}";
    hash = "sha256-/rYdOurPlpGKCMAXTAhoWRn4NU3usPpJmef3f8V8EQA=";
  };

  cargoHash = "sha256-8TmrsRbFC1TyoiUNVVTEdvDLj0BIJmqM00OoPLpaoFQ=";

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
