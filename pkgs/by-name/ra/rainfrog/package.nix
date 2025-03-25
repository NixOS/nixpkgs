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
  version = "0.2.16";
in
rustPlatform.buildRustPackage {
  inherit version;
  pname = "rainfrog";

  src = fetchFromGitHub {
    owner = "achristmascarl";
    repo = "rainfrog";
    tag = "v${version}";
    hash = "sha256-jolr2KIjmjriekATTQYqzHeBadQGYYj26aETZ2Dq0IU=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Q6tsJhtNt6Ph3qW2VJ+l3gg2VN0sgQ175YFqgXWu/C4=";

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
