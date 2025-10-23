{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "cargo-3ds";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "rust3ds";
    repo = "cargo-3ds";
    tag = "v${version}";
    hash = "sha256-UMeIxYxQ+0VGyDJTu78n9O5iXw3ZBg8mHqmnUtbnXo4=";
  };

  cargoHash = "sha256-ZH4JGBoXf6eTD35QPQBTIUYIlSyMOtWW2tWF5MkjqFk=";

  # Integration tests do not run in Nix build environment due to needing to
  # create and build Cargo workspaces.
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Cargo command to work with Nintendo 3DS project binaries";
    homepage = "https://github.com/rust3ds/cargo-3ds";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ l1npengtul ];
  };
}
