{
  lib,
  darwin,
  fetchFromGitHub,
  testers,
  nix-update-script,
  rustPlatform,
  stdenv,
  rainfrog,
}:
let
  version = "0.2.10";
in
rustPlatform.buildRustPackage {
  inherit version;
  pname = "rainfrog";

  src = fetchFromGitHub {
    owner = "achristmascarl";
    repo = "rainfrog";
    rev = "refs/tags/v${version}";
    hash = "sha256-hIhg6OeWCp27OPHg10ifjsSvPrBHQMnn4P3CmyYmdDk=";
  };

  cargoHash = "sha256-MYqVo+7xQzF55rEqUJNcB1SAEoxowHl+vOINCyr59nA=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin (
    with darwin.apple_sdk.frameworks;
    [
      AppKit
      CoreGraphics
      SystemConfiguration
    ]
  );

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
