{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "spacer";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "samwho";
    repo = "spacer";
    rev = "v${finalAttrs.version}";
    hash = "sha256-OryVQmecb8BgnEKeSvAQha+uiv+aZd2Q41T9tZTcWaI=";
  };

  cargoHash = "sha256-sFsERAvR99BZm7SmaL/5cmCrwVZIKGRiFYcBtSryFaw=";

  meta = {
    description = "CLI tool to insert spacers when command output stops";
    homepage = "https://github.com/samwho/spacer";
    changelog = "https://github.com/samwho/spacer/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "spacer";
  };
})
