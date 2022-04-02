{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "taskwarrior-tui";
  version = "0.21.1";

  src = fetchFromGitHub {
    owner = "kdheepak";
    repo = "taskwarrior-tui";
    rev = "v${version}";
    sha256 = "sha256-fgoK7Y+3h2VFfP8yiR8JM8Xf7UJbkX9PO1RoJRoYLW4=";
  };

  # Because there's a test that requires terminal access
  doCheck = false;

  cargoSha256 = "sha256-3rDvla1mCcQclALbomUTvE3aLzsMeIjcIbEv4KfCKZE=";

  meta = with lib; {
    description = "A terminal user interface for taskwarrior ";
    homepage = "https://github.com/kdheepak/taskwarrior-tui";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
