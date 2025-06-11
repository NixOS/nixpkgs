{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,

  python3,
  sqlite,
}:

rustPlatform.buildRustPackage rec {
  pname = "biliup-rs";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "biliup";
    repo = "biliup-rs";
    tag = "v${version}";
    hash = "sha256-Wpi5ONOzWL/NUUuIR4jaDcJFq7ZIYi7gkIxFIU3SLVY=";
  };

  nativeBuildInputs = [
    python3
    sqlite
  ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-4SH7ux15Sm7NJDY79x9O7oahvbjS4kZzzY/9UsLDq0U=";

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/biliup/biliup-rs/releases/tag/v${version}";
    description = "CLI tool for uploading videos to Bilibili";
    homepage = "https://biliup.github.io/biliup-rs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ oosquare ];
    mainProgram = "biliup";
    platforms = lib.platforms.all;
  };
}
