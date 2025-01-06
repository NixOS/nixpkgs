{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "spacer";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "samwho";
    repo = "spacer";
    rev = "v${version}";
    hash = "sha256-gxqUMtONjYPjSmxyguE9/GBC91PUK1rdFGsISGaSe44=";
  };

  cargoHash = "sha256-pMYqIl0Td2awAxe3BRglBcOychwTmFZ+pZV0QOT0CL4=";

  meta = {
    description = "CLI tool to insert spacers when command output stops";
    homepage = "https://github.com/samwho/spacer";
    changelog = "https://github.com/samwho/spacer/releases/tag/${src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ figsoda ];
    mainProgram = "spacer";
  };
}
