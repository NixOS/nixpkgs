{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "ttdl";
<<<<<<< HEAD
  version = "4.1.0";
=======
  version = "3.8.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "VladimirMarkelov";
    repo = "ttdl";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-twl72feo1PpWZbs50a962pvvD5YUHfZRW9OjY/meYVo=";
  };

  cargoHash = "sha256-ZoVPC/PyMm+yuDYhVFykIBk0T5RNLAfmIT36Tl/dxCo=";
=======
    sha256 = "sha256-6QfUy1Y7qFOdBFmDFQyRr+GJZSdH+pbU3dEcAjsV1JM=";
  };

  cargoHash = "sha256-N+mVfgbL22fmynmz4/xFNxQh7l455cH2jyuczc4XsM4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "A CLI tool to manage todo lists in todo.txt format";
    homepage = "https://github.com/VladimirMarkelov/ttdl";
    changelog = "https://github.com/VladimirMarkelov/ttdl/blob/v${version}/changelog";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ _3JlOy-PYCCKUi ];
  };
}
