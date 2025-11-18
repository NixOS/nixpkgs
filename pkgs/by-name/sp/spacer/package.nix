{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "spacer";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "samwho";
    repo = "spacer";
    rev = "v${version}";
    hash = "sha256-OryVQmecb8BgnEKeSvAQha+uiv+aZd2Q41T9tZTcWaI=";
  };

  cargoHash = "sha256-sFsERAvR99BZm7SmaL/5cmCrwVZIKGRiFYcBtSryFaw=";

  meta = with lib; {
    description = "CLI tool to insert spacers when command output stops";
    homepage = "https://github.com/samwho/spacer";
    changelog = "https://github.com/samwho/spacer/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "spacer";
  };
}
