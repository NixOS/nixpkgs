{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "obs-cmd";
  version = "0.17.7";

  src = fetchFromGitHub {
    owner = "grigio";
    repo = "obs-cmd";
    rev = "v${version}";
    hash = "sha256-+rsX86PrTlswi7uItyfOqYWziJ0kLl9X86TMtcmMCKo=";
  };

  cargoHash = "sha256-u+IHQiKEX0KUkwz4KsqwIgdo3KAxarPZgrmJWA1qQ50=";

  meta = with lib; {
    description = "Minimal CLI to control OBS Studio via obs-websocket";
    homepage = "https://github.com/grigio/obs-cmd";
    changelog = "https://github.com/grigio/obs-cmd/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ ianmjones ];
    mainProgram = "obs-cmd";
  };
}
