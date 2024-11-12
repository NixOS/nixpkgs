{ fetchFromGitHub
, rustPlatform
, lib
}:

rustPlatform.buildRustPackage rec{
  pname = "restls";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "3andne";
    repo = "restls";
    rev = "v${version}";
    hash = "sha256-nlQdBwxHVbpOmb9Wq+ap2i4KI1zJYT3SEqvedDbVH8Q=";
  };

  cargoHash = "sha256-KtNLLtStZ7SNndcPxWfNPA2duoXFVePrbNQFPUz2xFg=";

  meta = with lib; {
    homepage = "https://github.com/3andne/restls";
    changelog = "https://github.com/3andne/restls/releases/tag/${src.rev}";
    description = "Perfect Impersonation of TLS";
    license = licenses.bsd3;
    mainProgram = "restls";
    maintainers = with maintainers; [ oluceps ];
  };
}
