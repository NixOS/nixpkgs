{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  darwin,
  testers,
  nix-update-script,
  committed,
}:
let
  version = "1.1.2";
in
rustPlatform.buildRustPackage {
  pname = "committed";
  inherit version;

  src = fetchFromGitHub {
    owner = "crate-ci";
    repo = "committed";
    tag = "v${version}";
    hash = "sha256-dBNtzKqaaqJrKMNwamUY0DO9VCVqDyf45lT82nOn8UM=";
  };
  useFetchCargoVendor = true;
  cargoHash = "sha256-gWMS14945qa6pCe+Olg89gOaoZwRKsqJtG0jKe5/7e0=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  passthru = {
    tests.version = testers.testVersion { package = committed; };
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://github.com/crate-ci/committed";
    changelog = "https://github.com/crate-ci/committed/blob/v${version}/CHANGELOG.md";
    description = "Nitpicking commit history since beabf39";
    mainProgram = "committed";
    license = [
      lib.licenses.asl20 # or
      lib.licenses.mit
    ];
    maintainers = [ lib.maintainers.pigeonf ];
  };
}
