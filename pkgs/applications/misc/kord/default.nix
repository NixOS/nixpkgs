{ lib
<<<<<<< HEAD
, stdenv
, darwin
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, fetchFromGitHub
, rustPlatform
, pkg-config
, alsa-lib
}:

rustPlatform.buildRustPackage rec {
  pname = "kord";
<<<<<<< HEAD
  version = "0.6.1";
=======
  version = "0.4.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # kord depends on nightly features
  RUSTC_BOOTSTRAP = 1;

  src = fetchFromGitHub {
    owner = "twitchax";
    repo = "kord";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-CeMh6yB4fGoxtGLbkQe4OMMvBM0jesyP+8JtU5kCP84=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "bincode-2.0.0-rc.2" = "sha256-0BfKKGOi5EVIoF0HvIk0QS2fHUMG3tpsMLe2SkXeZlo=";
    };
  };

  nativeBuildInputs = lib.optionals stdenv.isLinux [ pkg-config ]
    ++ lib.optionals stdenv.isDarwin [ rustPlatform.bindgenHook ];

  buildInputs = lib.optionals stdenv.isLinux [ alsa-lib ]
    ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.AudioUnit ];
=======
    sha256 = "sha256-B/UwnbzXI3ER8IMOVtn0ErVqFrkZXKoL+l7ll1AlzDg=";
  };

  cargoHash = "sha256-xhWSycTe72HW3E9meTo4wjOCHDcNq6fUPT6nqHoW9vE=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ alsa-lib ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "A music theory binary and library for Rust";
    homepage = "https://github.com/twitchax/kord";
    maintainers = with maintainers; [ kidsan ];
    license = with licenses; [ mit ];
  };
}
