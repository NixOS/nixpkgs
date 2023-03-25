{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "ttdl";
  version = "3.7.0";

  src = fetchFromGitHub {
    owner = "VladimirMarkelov";
    repo = "ttdl";
    rev = "v${version}";
    sha256 = "sha256-4XmOFoj2kynQZzos/vf0rciJCGfnFLN7f1MG9NU53os=";
  };

  cargoHash = "sha256-9TyEHAlxTNx/ildlqEjuFIKfmUQQFQSVoxcrb2Tg9Ps=";

  meta = with lib; {
    description = "A CLI tool to manage todo lists in todo.txt format";
    homepage = "https://github.com/VladimirMarkelov/ttdl";
    changelog = "https://github.com/VladimirMarkelov/ttdl/blob/v${version}/changelog";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ _3JlOy-PYCCKUi ];
  };
}
