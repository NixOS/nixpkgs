{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  zstd,
  unstableGitUpdater,
}:

rustPlatform.buildRustPackage {
  pname = "nix-check-deps";
  version = "0-unstable-2026-08-17";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "GrimmTheShrimp";
    repo = "nix-check-deps";
    rev = "8012947337c0be458524153917b8f1b4e44dab0b";
    hash = "sha256-CJZRpEizw1x07WA5hpOqQePcxM2SzPox2woe5iGv8/I=";
  };

  cargoHash = "sha256-FUwPRbFpKXz/qAyj2oK+NGidD1E08vKqQ/5F4qQVwSk=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ zstd ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Scan nix packages for unused buildInputs";
    homepage = "https://github.com/GrimmTheShrimp/nix-check-deps";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    mainProgram = "nix-check-deps";
    platforms = lib.platforms.unix;
  };
}
