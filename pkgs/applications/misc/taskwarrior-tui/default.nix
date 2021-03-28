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

  cargoSha256 = "0xblxsp7jgqbb3kr5k7yy6ziz18a8wlkrhls0vz9ak2n0ngddg3r";

  meta = with lib; {
    description = "A terminal user interface for taskwarrior ";
    homepage = "https://github.com/kdheepak/taskwarrior-tui";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
