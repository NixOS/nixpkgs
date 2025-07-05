{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "spacer";
  version = "0.3.9";

  src = fetchFromGitHub {
    owner = "samwho";
    repo = "spacer";
    rev = "v${version}";
    hash = "sha256-8c8l8SJlh3z8spembPavO4fhzPcpCfaZVvU8dl3PUTc=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-WNqzOZ38ogeeEYB6B58+C2VptJ/HNj5+DpWvvHBhTAQ=";

  meta = with lib; {
    description = "CLI tool to insert spacers when command output stops";
    homepage = "https://github.com/samwho/spacer";
    changelog = "https://github.com/samwho/spacer/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "spacer";
  };
}
