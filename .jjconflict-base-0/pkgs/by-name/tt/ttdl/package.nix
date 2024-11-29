{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "ttdl";
  version = "4.5.0";

  src = fetchFromGitHub {
    owner = "VladimirMarkelov";
    repo = "ttdl";
    rev = "v${version}";
    sha256 = "sha256-ahAqKf4ZFpyR2ZnrdJ2FWR4ZBd0Q+ZnqYfhc6Z7rM8Q=";
  };

  cargoHash = "sha256-MHWPeqCZ/EpDEkKg2M819C6jbjpFa0oheiiPkW8x/3Q=";

  meta = with lib; {
    description = "CLI tool to manage todo lists in todo.txt format";
    homepage = "https://github.com/VladimirMarkelov/ttdl";
    changelog = "https://github.com/VladimirMarkelov/ttdl/blob/v${version}/changelog";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ _3JlOy-PYCCKUi ];
    mainProgram = "ttdl";
  };
}
