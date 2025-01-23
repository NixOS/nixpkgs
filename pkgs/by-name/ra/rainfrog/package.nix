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
  version = "0.2.11";
in
rustPlatform.buildRustPackage {
  inherit version;
  pname = "rainfrog";

  src = fetchFromGitHub {
    owner = "achristmascarl";
    repo = "rainfrog";
    tag = "v${version}";
    hash = "sha256-gtiwkgNyqq+KMATkzaLOjPB6jcjVAM2qq6zwZ1WGkPE=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-7LhCNlbO9MTz2SxxQozdyvxG1uBum9oXaUjXXFS0USs=";

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
