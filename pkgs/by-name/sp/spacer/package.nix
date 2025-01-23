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

  useFetchCargoVendor = true;
  cargoHash = "sha256-OZzelg7UZiCcPXUNbmN5gwL5RctiVWseQIZzOaJdFSU=";

  meta = with lib; {
    description = "CLI tool to insert spacers when command output stops";
    homepage = "https://github.com/samwho/spacer";
    changelog = "https://github.com/samwho/spacer/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "spacer";
  };
}
