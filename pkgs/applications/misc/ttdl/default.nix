{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "ttdl";
  version = "3.6.3";

  src = fetchFromGitHub {
    owner = "VladimirMarkelov";
    repo = "ttdl";
    rev = "v${version}";
    sha256 = "sha256-IR0cDXQHnMDI71Vg50atS98YorqAQKc95EF1+m9cxFY=";
  };

  cargoSha256 = "sha256-658mN3R3opjvqfnIDcbh11ZSOTDbpYnhCgGGx46Mrrc=";

  meta = with lib; {
    description = "A CLI tool to manage todo lists in todo.txt format";
    homepage = "https://github.com/VladimirMarkelov/ttdl";
    changelog = "https://github.com/VladimirMarkelov/ttdl/blob/v${version}/changelog";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ _3JlOy-PYCCKUi ];
  };
}
