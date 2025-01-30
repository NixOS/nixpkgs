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

  cargoHash = "sha256-/laEbJ1kev7CpDZ4ygrZr1jMI9n6QtVPOwf22NFOZGU=";

  meta = with lib; {
    description = "CLI tool to insert spacers when command output stops";
    homepage = "https://github.com/samwho/spacer";
    changelog = "https://github.com/samwho/spacer/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "spacer";
  };
}
