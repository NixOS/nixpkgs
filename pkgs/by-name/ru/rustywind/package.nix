{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "rustywind";
  version = "0.24.0";

  src = fetchFromGitHub {
    owner = "avencera";
    repo = "rustywind";
    rev = "v${version}";
    hash = "sha256-3cLpyY2Ec3XUDUoq4QLyDx8Nr85TOevBkfoReguVGII=";
  };

  cargoHash = "sha256-jq8d+ndPOu07YO5PJ5YfWTeG70bZnr0i8vMwv7Dw5GY=";

  meta = with lib; {
    description = "CLI for organizing Tailwind CSS classes";
    mainProgram = "rustywind";
    homepage = "https://github.com/avencera/rustywind";
    changelog = "https://github.com/avencera/rustywind/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
