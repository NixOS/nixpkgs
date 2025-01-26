{
  lib,
  fetchFromGitea,
  rustPlatform,
  pkg-config,
  openssl,
  curl,
}:
rustPlatform.buildRustPackage rec {
  pname = "pay-respects";
  version = "0.6.11";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "iff";
    repo = "pay-respects";
    rev = "v${version}";
    hash = "sha256-4m8/sp6r2Xb2SsNcatMv0+mWHBx+XKD0LEzrEwuWIEA=";
  };

  cargoHash = "sha256-obuMixkXqWUuZFqs3mJyMpHx4RY70ZpE3H9GzqFmt6k=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    curl
  ];

  meta = {
    description = "Terminal command correction, alternative to `thefuck`, written in Rust";
    homepage = "https://codeberg.org/iff/pay-respects";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [
      sigmasquadron
      bloxx12
      ALameLlama
    ];
    mainProgram = "pay-respects";
  };
}
