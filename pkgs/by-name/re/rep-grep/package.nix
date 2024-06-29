{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "rep-grep";
  version = "0-unstable-2024-02-06";

  src = fetchFromGitHub {
    owner = "robenkleene";
    repo = "rep-grep";
    rev = "10510d47e392cb9d30a861c69f702fd194b3fa88";
    hash = "sha256-/dH+mNtNHaYFndVhoqmz4Sc3HeemoQt1HGD98mb9Qhw=";
  };

  cargoHash = "sha256-ch+RMLc+xogL0gkrnw+n+bmUVIcixdPTaNPHPuJ0/EI=";

  meta = with lib; {
    description = "Command-line utility that takes grep-formatted lines and performs a find-and-replace on them";
    homepage = "https://github.com/robenkleene/rep-grep";
    license = licenses.mit;
    maintainers = with maintainers; [ philiptaron ];
    mainProgram = "rep";
  };
}
