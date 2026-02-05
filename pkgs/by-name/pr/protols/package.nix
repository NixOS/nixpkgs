{
  lib,
  protobuf,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "protols";
  version = "0.13.2";

  src = fetchFromGitHub {
    owner = "coder3101";
    repo = "protols";
    tag = version;
    hash = "sha256-kPYCvkPVxWDNgYpieDMIwvM7Q/HWKu0hNbKW1K5jo+Y=";
  };

  cargoHash = "sha256-TIzPXQm9SPi1H+KpZuoLag1C90skMiKQvTwXVt6jy+0=";

  env.FALLBACK_INCLUDE_PATH = "${protobuf}/include";

  meta = {
    description = "Protocol Buffers language server written in Rust";
    homepage = "https://github.com/coder3101/protols";
    changelog = "https://github.com/coder3101/protols/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nartsiss ];
    mainProgram = "protols";
  };
}
