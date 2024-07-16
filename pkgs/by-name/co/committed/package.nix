{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, darwin
, nix-update-script
, versionCheckHook
}:
let
  version = "1.0.20";
in
rustPlatform.buildRustPackage {
  pname = "committed";
  inherit version;

  src = fetchFromGitHub {
    owner = "crate-ci";
    repo = "committed";
    rev = "refs/tags/v${version}";
    hash = "sha256-HqZYxV2YjnK7Q3A7B6yVFXME0oc3DZ4RfMkDGa2IQxA=";
  };
  cargoHash = "sha256-AmAEGVWq6KxLtiHDGIFVcoP1Wck8z+P9mnDy0SSSJNM=";

  buildInputs = lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
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
