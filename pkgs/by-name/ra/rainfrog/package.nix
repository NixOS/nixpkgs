{
  lib,
  fetchFromGitHub,
  testers,
  nix-update-script,
  rustPlatform,
  rainfrog,
}:
let
  version = "0.3.1";
in
rustPlatform.buildRustPackage {
  inherit version;
  pname = "rainfrog";

  src = fetchFromGitHub {
    owner = "achristmascarl";
    repo = "rainfrog";
    tag = "v${version}";
    hash = "sha256-sUZnHlTxOz0j2KsWi/qaI5MYT0mkANn6deH54TS/JYw=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-wgJWPlURS2DxcRMzDEAXa50nQswcjbe0zj2QgF0HZys=";

  passthru = {
    tests.version = testers.testVersion {
      package = rainfrog;

      command = ''
        RAINFROG_DATA="$(mktemp -d)" rainfrog --version
      '';
    };

    updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://github.com/achristmascarl/rainfrog/releases/tag/v${version}";
    description = "A database management TUI for postgres";
    homepage = "https://github.com/achristmascarl/rainfrog";
    license = lib.licenses.mit;
    mainProgram = "rainfrog";
    maintainers = with lib.maintainers; [ patka ];
  };
}
