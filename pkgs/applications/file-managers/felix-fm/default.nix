{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, bzip2
, zstd
, zoxide
}:

rustPlatform.buildRustPackage rec {
  pname = "felix";
<<<<<<< HEAD
  version = "2.8.1";

  src = fetchFromGitHub {
    owner = "kyoheiu";
    repo = "felix";
    rev = "v${version}";
    hash = "sha256-RDCX5+Viq/VRb0SXUYxCtWF+aVahI5WGhp9/Vn+uHqI=";
  };

  cargoHash = "sha256-kgI+afly+/Ag0witToM95L9b3yQXP5Gskwl4Lf4SusY=";
=======
  version = "2.2.7";

  src = fetchFromGitHub {
    owner = "kyoheiu";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ShC6V3NAD5Gv5nLG5e6inoOEEpZn4EuQkaRoGn94Z1g=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "syntect-5.0.0" = "sha256-ZVCQIVUKwNdV6tyep9THvyM132faDK48crgpWEHrRSQ=";
    };
  };
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    bzip2
    zstd
  ];

  nativeCheckInputs = [ zoxide ];

  buildFeatures = [ "zstd/pkg-config" ];

  checkFlags = [
    # extra test files not shipped with the repository
    "--skip=functions::tests::test_list_up_contents"
    "--skip=state::tests::test_has_write_permission"
  ];

<<<<<<< HEAD
  # Cargo.lock is outdated
  postConfigure = ''
    cargo metadata --offline
  '';

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "A tui file manager with vim-like key mapping";
    homepage = "https://github.com/kyoheiu/felix";
    changelog = "https://github.com/kyoheiu/felix/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "fx";
  };
}
