{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "mdsh";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "zimbatm";
    repo = "mdsh";
    rev = "v${version}";
    hash = "sha256-ammLbKEKXDSuZMr4DwPpcRSkKh7BzNC+4ZRCqTNNCQk=";
  };

  cargoHash = "sha256-wLHMccxk3ceZyGK27t5Kyal48yj9dQNgmEHjH9hR9Pc=";

  meta = with lib; {
    description = "Markdown shell pre-processor";
    homepage = "https://github.com/zimbatm/mdsh";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ zimbatm ];
    mainProgram = "mdsh";
  };
}
