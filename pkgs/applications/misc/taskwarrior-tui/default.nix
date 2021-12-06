{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "taskwarrior-tui";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "kdheepak";
    repo = "taskwarrior-tui";
    rev = "v${version}";
    sha256 = "sha256-OrRFKBUN5NJ8HT/RMIJBo05y2o7rb1/pQx99HGW8w9E=";
  };

  # Because there's a test that requires terminal access
  doCheck = false;

  cargoSha256 = "sha256-H0LlvGC7gXIqhbiqeGjAW69bL1bwB5YAUKrfqDaJXtk=";

  meta = with lib; {
    description = "A terminal user interface for taskwarrior ";
    homepage = "https://github.com/kdheepak/taskwarrior-tui";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
