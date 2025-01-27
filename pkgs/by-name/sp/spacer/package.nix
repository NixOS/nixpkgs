{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "spacer";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "samwho";
    repo = "spacer";
    rev = "v${version}";
    hash = "sha256-gEJUHNtoLurBMhSMoJUiJMm6xLjUJNjTejPwkgltf2U=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-naNhEDWOnhZ6lYgHP3p76pSsrQLqYuQ+kazCks7QciA=";

  meta = with lib; {
    description = "CLI tool to insert spacers when command output stops";
    homepage = "https://github.com/samwho/spacer";
    changelog = "https://github.com/samwho/spacer/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "spacer";
  };
}
