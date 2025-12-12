{
  fetchFromGitHub,
  rustPlatform,
  lib,
}:

rustPlatform.buildRustPackage rec {
  pname = "restls";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "3andne";
    repo = "restls";
    rev = "v${version}";
    hash = "sha256-nlQdBwxHVbpOmb9Wq+ap2i4KI1zJYT3SEqvedDbVH8Q=";
  };

  cargoHash = "sha256-hub64iZNVw/BJjibtDnJ3boIU27DEbYSlMLhFFVJ9ps=";

  meta = {
    homepage = "https://github.com/3andne/restls";
    changelog = "https://github.com/3andne/restls/releases/tag/${src.rev}";
    description = "Perfect Impersonation of TLS";
    license = lib.licenses.bsd3;
    mainProgram = "restls";
    maintainers = with lib.maintainers; [ oluceps ];
  };
}
