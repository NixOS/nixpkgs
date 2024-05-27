{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "ttdl";
  version = "4.3.0";

  src = fetchFromGitHub {
    owner = "VladimirMarkelov";
    repo = "ttdl";
    rev = "v${version}";
    sha256 = "sha256-5v3Eu85x3xNvTRgfxhlDz4hiJ4UO010pZPY7UPHk7mQ=";
  };

  cargoHash = "sha256-+jYl/oUeJaABgDX/OBTyeo/B7RYc2MUTreU1ySLG0XQ=";

  meta = with lib; {
    description = "A CLI tool to manage todo lists in todo.txt format";
    homepage = "https://github.com/VladimirMarkelov/ttdl";
    changelog = "https://github.com/VladimirMarkelov/ttdl/blob/v${version}/changelog";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ _3JlOy-PYCCKUi ];
    mainProgram = "ttdl";
  };
}
