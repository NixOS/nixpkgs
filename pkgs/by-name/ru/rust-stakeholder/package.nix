{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:
rustPlatform.buildRustPackage {
  pname = "rust-stakeholder";
  version = "0-unstable-2025-03-15";

  src = fetchFromGitHub {
    owner = "giacomo-b";
    repo = "rust-stakeholder";
    rev = "aacdccbed72be34e0231e6d15cecb6d87a9a5ef6";
    hash = "sha256-YnXqvZlItCoAUEYUpRVQLM4fuLaf9Wd+OFY9ItSg25U=";
  };

  cargoHash = "sha256-NxO+7Wh8Ff6RPFtmbEa3EJszfDaZDXGWZDAoXPEAnpI=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Generate impressive-looking terminal output to look busy when stakeholders walk by";
    homepage = "https://github.com/giacomo-b/rust-stakeholder";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.awwpotato ];
    mainProgram = "rust-stakeholder";
  };
}
