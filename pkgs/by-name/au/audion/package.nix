{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "audion";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "audiusGmbH";
    repo = "audion";
    tag = finalAttrs.version;
    hash = "sha256-r/ZJ9c2PEl8/AhMlsQaHkVQ9uv5R/qEW66rLSJRGxQk=";
  };

  cargoHash = "sha256-f+O/McbMnufNERpZgb8K2CiTeTPXqnX+kJd57zQu474=";

  meta = {
    description = "Ping the host continuously and write results to a file";
    homepage = "https://github.com/audiusGmbH/audion";
    changelog = "https://github.com/audiusGmbH/audion/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "audion";
  };
})
