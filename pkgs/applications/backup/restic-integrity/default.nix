{ lib
, rustPlatform
, fetchFromGitLab
}:

rustPlatform.buildRustPackage rec {
  pname = "restic-integrity";
  version = "1.2.1";
  src = fetchFromGitLab {
    domain = "gitlab.upi.li";
    owner = "networkException";
    repo = "restic-integrity";
    rev = version;
    hash = "sha256-/n8muqW9ol0AY9RM3N4nqLDw0U1h0308M1uRCMS2kOM=";
  };

  cargoHash = "sha256-TYDPzjWxTK9hQhzSknkCao9lq9UjZN3yQX3wtkMmP6E=";

  meta = with lib; {
    description = "A CLI tool to check the integrity of a restic repository without unlocking it";
    homepage = "https://gitlab.upi.li/networkException/restic-integrity";
    license = with licenses; [ bsd2 ];
    maintainers = with maintainers; [ janik ];
    mainProgram = "restic-integrity";
  };
}
