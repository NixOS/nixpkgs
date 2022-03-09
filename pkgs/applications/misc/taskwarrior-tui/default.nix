{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "taskwarrior-tui";
  version = "0.20.1";

  src = fetchFromGitHub {
    owner = "kdheepak";
    repo = "taskwarrior-tui";
    rev = "v${version}";
    sha256 = "sha256-NE0GKQ3ROD+AF5FCuaKJ+8g+wiYobVK8swK0F9jo2Lk=";
  };

  # Because there's a test that requires terminal access
  doCheck = false;

  cargoSha256 = "sha256-hO5rff3bm8g3JYh5vFhj2L3f/hOgP0ZA0EhO3YF5DFw=";

  meta = with lib; {
    description = "A terminal user interface for taskwarrior ";
    homepage = "https://github.com/kdheepak/taskwarrior-tui";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
