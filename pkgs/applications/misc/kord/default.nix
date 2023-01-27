{ lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, alsa-lib
}:

rustPlatform.buildRustPackage rec {
  pname = "kord";
  version = "0.4.2";

  # kord depends on nightly features
  RUSTC_BOOTSTRAP = 1;

  src = fetchFromGitHub {
    owner = "twitchax";
    repo = "kord";
    rev = "v${version}";
    sha256 = "sha256-B/UwnbzXI3ER8IMOVtn0ErVqFrkZXKoL+l7ll1AlzDg=";
  };

  cargoHash = "sha256-xhWSycTe72HW3E9meTo4wjOCHDcNq6fUPT6nqHoW9vE=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ alsa-lib ];

  meta = with lib; {
    description = "A music theory binary and library for Rust";
    homepage = "https://github.com/twitchax/kord";
    maintainers = with maintainers; [ kidsan ];
    license = with licenses; [ mit ];
  };
}
