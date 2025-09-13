{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "fre";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "camdencheek";
    repo = "fre";
    rev = "v${version}";
    hash = "sha256-cYqEPohqUmewvBUoGJQfa4ATxw2uny5+nUKtNzrxK38=";
  };

  cargoHash = "sha256-07qKG4ju2UOkTcgWAl2U0uqQZyiosK1UH/M2BvwMAaU=";

  meta = {
    description = "CLI tool for tracking your most-used directories and files";
    homepage = "https://github.com/camdencheek/fre";
    changelog = "https://github.com/camdencheek/fre/blob/${version}/CHANGELOG.md";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ gaykitty ];
    mainProgram = "fre";
  };
}
