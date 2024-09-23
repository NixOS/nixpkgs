{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "ttyper";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "max-niederman";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-g4OD4Mc3KHN9rrzM+9JvN2xTnSojGQy6yptdGj3zgW4=";
  };

  cargoHash = "sha256-EXBs73651lP2B/1lAGHLcc9F1Xi+Bj6+c9wv2uX56Lg=";

  meta = with lib; {
    description = "Terminal-based typing test";
    homepage = "https://github.com/max-niederman/ttyper";
    changelog = "https://github.com/max-niederman/ttyper/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda max-niederman ];
    mainProgram = "ttyper";
  };
}
