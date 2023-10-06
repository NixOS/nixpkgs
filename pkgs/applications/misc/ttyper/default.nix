{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "ttyper";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "max-niederman";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-b6yxl7dCPLWnzsrRKegubtLDLObOnCf7kvZtkobzC1o=";
  };

  cargoHash = "sha256-N+JJV+q/tIMN60x9DdD/i2+9Wp44kzpMb09dsrSceEk=";

  meta = with lib; {
    description = "Terminal-based typing test";
    homepage = "https://github.com/max-niederman/ttyper";
    changelog = "https://github.com/max-niederman/ttyper/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda max-niederman ];
  };
}
