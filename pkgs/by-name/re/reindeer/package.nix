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
<<<<<<< HEAD
  version = "2025.12.22.00";
=======
  version = "2025.11.24.00";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "facebookincubator";
    repo = "reindeer";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-9e3QWszac5P1OhhM2VOFYPPMJmzv5MdWHwL0O8Dq+v0=";
  };

  cargoHash = "sha256-G8Q7mhWRLWx91bRb8apcMFy1s+nxtsXMhDwZVoZTRfA=";
=======
    hash = "sha256-oDmtImomFDCLK1T/qxFrHPQC7iWGbLv5L9GcRoXnvz4=";
  };

  cargoHash = "sha256-1wOumpyWMtJH1QL0XXEWrVz2JTIxh5Dhz9GqX1NBpLw=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  passthru.updateScript = nix-update-script { };

<<<<<<< HEAD
  meta = {
    description = "Generate Buck build rules from Rust Cargo dependencies";
    mainProgram = "reindeer";
    homepage = "https://github.com/facebookincubator/reindeer";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ nickgerace ];
=======
  meta = with lib; {
    description = "Generate Buck build rules from Rust Cargo dependencies";
    mainProgram = "reindeer";
    homepage = "https://github.com/facebookincubator/reindeer";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ nickgerace ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
