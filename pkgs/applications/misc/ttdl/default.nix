{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "ttdl";
  version = "3.10.0";

  src = fetchFromGitHub {
    owner = "VladimirMarkelov";
    repo = "ttdl";
    rev = "v${version}";
    sha256 = "sha256-46oqQaDYFxpSjqFdP2V0aBP1S6BDG+hSO/V76WwCzAQ=";
  };

  cargoHash = "sha256-Kol7pCHq91zOE9boRatv12pgh/rfra5snUe3HNho1DU=";

  meta = with lib; {
    description = "A CLI tool to manage todo lists in todo.txt format";
    homepage = "https://github.com/VladimirMarkelov/ttdl";
    changelog = "https://github.com/VladimirMarkelov/ttdl/blob/v${version}/changelog";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ _3JlOy-PYCCKUi ];
  };
}
