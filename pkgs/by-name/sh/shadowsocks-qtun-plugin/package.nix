{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "shadowsocks-qtun-plugin";
  version = "0.3.0-unstable-09-06-2025";

  src = fetchFromGitHub {
    owner = "shadowsocks";
    repo = "qtun";
    # v0.3.0 with Cargo.lock
    rev = "32580a273f027a2dd40e83d93a2dd8c0f683eea4";
    hash = "sha256-T+x+km3a8Tkq8oOTW3t/+gE+J/+XZFPUZauarOCOMa8=";
  };

  cargoHash = "sha256-BqtR5P2Bi4blw32EDvWIgRtR9tVck3OgwkEs54IY+Hc=";

  meta = {
    description = "Yet another SIP003 plugin based on IETF-QUIC";
    homepage = "https://github.com/shadowsocks/qtun";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ neverbehave ];
    mainProgram = "qtun-server";
  };
}
