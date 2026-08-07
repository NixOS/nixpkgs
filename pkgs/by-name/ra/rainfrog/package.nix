{
  lib,
  fetchFromGitHub,
  testers,
  nix-update-script,
  rustPlatform,
  rainfrog,
}:
let
  version = "0.4.2";
in
rustPlatform.buildRustPackage {
  inherit version;
  pname = "rainfrog";

  src = fetchFromGitHub {
    owner = "achristmascarl";
    repo = "rainfrog";
    tag = "v${version}";
    hash = "sha256-oHskvXl8JX6rYWBhfFYmrwV31VWZl8fd/MDBHpJzBjo=";
  };

  cargoHash = "sha256-wx7BAUjt93WNtpx6k/cG9G2N6OWxMcEM+uuISPqc+KY=";

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
    description = "Database management TUI for postgres";
    homepage = "https://github.com/achristmascarl/rainfrog";
    license = lib.licenses.mit;
    mainProgram = "rainfrog";
    maintainers = with lib.maintainers; [ patka ];
  };
}
