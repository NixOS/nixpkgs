{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "proton-caller";
  version = "3.1.2";

  src = fetchFromGitHub {
    owner = "caverym";
    repo = "proton-caller";
    rev = version;
    sha256 = "sha256-srzahBMihkEP9/+7oRij5POHkCcH6QBh4kGz42Pz0nM=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-AZp6Mbm9Fg+EVr31oJe6/Z8LIwapYhos8JpZzPMiwz0=";

  meta = with lib; {
    description = "Run Windows programs with Proton";
    changelog = "https://github.com/caverym/proton-caller/releases/tag/${version}";
    homepage = "https://github.com/caverym/proton-caller";
    license = licenses.mit;
    maintainers = with maintainers; [ kho-dialga ];
    mainProgram = "proton-call";
  };
}
