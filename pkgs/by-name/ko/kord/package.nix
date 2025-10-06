{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  rustPlatform,
  pkg-config,
  alsa-lib,
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

  cargoHash = "sha256-DpZsi2eIhuetHnLLYGAvv871mbPfAIUevqBLaV8ljGA=";

  patches = [
    # Fixes build issues due to refactored Rust compiler feature annotations.
    # Should be removable with the next release after v. 0.6.1.
    (fetchpatch {
      name = "fix-rust-features.patch";
      url = "https://github.com/twitchax/kord/commit/fa9bb979b17d77f54812a915657c3121f76c5d82.patch";
      hash = "sha256-XQu9P7372J2dHWzvpvbPtALS0Bh8EC+J1EyG3qlak2M=";
      excludes = [ "Cargo.*" ];
    })
  ];

  nativeBuildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [ pkg-config ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ rustPlatform.bindgenHook ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ alsa-lib ];

  meta = with lib; {
    description = "Music theory binary and library for Rust";
    homepage = "https://github.com/twitchax/kord";
    maintainers = with maintainers; [ kidsan ];
    license = with licenses; [ mit ];
  };
}
