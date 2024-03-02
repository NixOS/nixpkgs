{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "ttdl";
  version = "4.2.1";

  src = fetchFromGitHub {
    owner = "VladimirMarkelov";
    repo = "ttdl";
    rev = "v${version}";
    sha256 = "sha256-fspqUzF3QqFpd16J1dbcNMdqjcR3PIiRu/s+VB4KgwQ=";
  };

  cargoHash = "sha256-dvzm9lbVGGM4t6KZcHSlqwo55jssxi8HyFREMaj5I0Q=";

  meta = with lib; {
    description = "A CLI tool to manage todo lists in todo.txt format";
    homepage = "https://github.com/VladimirMarkelov/ttdl";
    changelog = "https://github.com/VladimirMarkelov/ttdl/blob/v${version}/changelog";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ _3JlOy-PYCCKUi ];
    mainProgram = "ttdl";
  };
}
