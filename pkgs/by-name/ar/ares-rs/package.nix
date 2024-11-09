{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "ares-rs";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "bee-san";
    repo = "ares";
    rev = "refs/tags/v${version}";
    hash = "sha256-F+uBGRL1G8kiNZUCsiPbISBfId5BPwShenusqkcsHug=";
  };

  cargoHash = "sha256-c50HCwWwW4Fyg6hC1JqBfKtwq6kgReSOIBYXvwm04yA=";

  meta = with lib; {
    description = "Automated decoding of encrypted text without knowing the key or ciphers used";
    homepage = "https://github.com/bee-san/ares";
    changelog = "https://github.com/bee-san/Ares/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "ares";
  };
}
