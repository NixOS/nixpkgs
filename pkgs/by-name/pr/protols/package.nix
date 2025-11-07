{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "protols";
  version = "0.12.9";

  src = fetchFromGitHub {
    owner = "coder3101";
    repo = "protols";
    tag = version;
    hash = "sha256-WHVvcTWMpID6Yxi3/ZEnslZQTphp8ew0U05GTmdBMeg=";
  };

  cargoHash = "sha256-10DU8/j9+LvT42r4Hyk0kdgQHEtDrZ4FZBQwlSGapPw=";

  meta = {
    description = "Protocol Buffers language server written in Rust";
    homepage = "https://github.com/coder3101/protols";
    changelog = "https://github.com/coder3101/protols/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nartsiss ];
    mainProgram = "protols";
  };
}
