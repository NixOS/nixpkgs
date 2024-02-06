{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "ttdl";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "VladimirMarkelov";
    repo = "ttdl";
    rev = "v${version}";
    sha256 = "sha256-twl72feo1PpWZbs50a962pvvD5YUHfZRW9OjY/meYVo=";
  };

  cargoHash = "sha256-ZoVPC/PyMm+yuDYhVFykIBk0T5RNLAfmIT36Tl/dxCo=";

  meta = with lib; {
    description = "A CLI tool to manage todo lists in todo.txt format";
    homepage = "https://github.com/VladimirMarkelov/ttdl";
    changelog = "https://github.com/VladimirMarkelov/ttdl/blob/v${version}/changelog";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ _3JlOy-PYCCKUi ];
  };
}
