{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-d2";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "danieleades";
    repo = "mdbook-d2";
    rev = "v${version}";
    hash = "sha256-+WCtvZXU8/FzOrc7LkxZKs5BhSdhqpOruxRfv+YY8Es=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-bTPqvWl41r1ilKjUpCJNKi3MsWeiix38xma5im/LLKQ=";
  doCheck = false;

  meta = with lib; {
    description = "D2 diagram generator plugin for MdBook";
    mainProgram = "mdbook-d2";
    homepage = "https://github.com/danieleades/mdbook-d2";
    changelog = "https://github.com/danieleades/mdbook-d2/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
