{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-d2";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "danieleades";
    repo = "mdbook-d2";
    rev = "v${version}";
    hash = "sha256-iVPB4SAzspw8gZHzEQVFRbFjyPCkxrvXvhMszopzslE=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-9D/osDyFwIhgv3scnnpsdN6S4qCPWuAU9tajENyWaXo=";
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
