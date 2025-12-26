{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "reindeer";
  version = "2025.12.22.00";

  src = fetchFromGitHub {
    owner = "facebookincubator";
    repo = "reindeer";
    tag = "v${version}";
    hash = "sha256-9e3QWszac5P1OhhM2VOFYPPMJmzv5MdWHwL0O8Dq+v0=";
  };

  cargoHash = "sha256-G8Q7mhWRLWx91bRb8apcMFy1s+nxtsXMhDwZVoZTRfA=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Generate Buck build rules from Rust Cargo dependencies";
    mainProgram = "reindeer";
    homepage = "https://github.com/facebookincubator/reindeer";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ nickgerace ];
  };
}
