{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "csvlens";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "YS-L";
    repo = "csvlens";
    rev = "refs/tags/v${version}";
    hash = "sha256-KileDwgVnrbJ6sCv6d4PjnyYqrEmZK6JESYa7+rBneo=";
  };

  cargoHash = "sha256-RtnfyhWfctByh8QqOMAu32xKSigP+lCIUIDfzj7kOkE=";

  meta = with lib; {
    description = "Command line csv viewer";
    homepage = "https://github.com/YS-L/csvlens";
    changelog = "https://github.com/YS-L/csvlens/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
    mainProgram = "csvlens";
  };
}
