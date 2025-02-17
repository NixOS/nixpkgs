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
  version = "0.2.13";
in
rustPlatform.buildRustPackage {
  inherit version;
  pname = "rainfrog";

  src = fetchFromGitHub {
    owner = "achristmascarl";
    repo = "rainfrog";
    tag = "v${version}";
    hash = "sha256-CNxaCA7xrAkSCiVao+s5jAp3fheRCYK+/3Yekr1xUKk=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Tl4T5EJGzrPal6ufgbtBwe6wfqI7SC5KbPZslCHe0Qs=";

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
