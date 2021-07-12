{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "taskwarrior-tui";
  version = "0.10.4";

  src = fetchFromGitHub {
    owner = "kdheepak";
    repo = "taskwarrior-tui";
    rev = "v${version}";
    sha256 = "1rs6xpnmqzp45jkdzi8x06i8764gk7zl86sp6s0hiirbfqf7vwsy";
  };

  # Because there's a test that requires terminal access
  doCheck = false;

  cargoSha256 = "1c9vw1n6h7irwim1zf3mr0g520jnlvfqdy7y9v9g9xpkvbjr7ich";

  meta = with lib; {
    description = "A terminal user interface for taskwarrior ";
    homepage = "https://github.com/kdheepak/taskwarrior-tui";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
