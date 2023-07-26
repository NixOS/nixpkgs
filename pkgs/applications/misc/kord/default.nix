{ lib
, stdenv
, darwin
, fetchFromGitHub
, rustPlatform
, pkg-config
, alsa-lib
}:

rustPlatform.buildRustPackage rec {
  pname = "kord";
  version = "0.6.1";

  # kord depends on nightly features
  RUSTC_BOOTSTRAP = 1;

  src = fetchFromGitHub {
    owner = "twitchax";
    repo = "kord";
    rev = "v${version}";
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

  meta = with lib; {
    description = "A music theory binary and library for Rust";
    homepage = "https://github.com/twitchax/kord";
    maintainers = with maintainers; [ kidsan ];
    license = with licenses; [ mit ];
  };
}
