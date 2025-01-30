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
  version = "0.6.12";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "iff";
    repo = "pay-respects";
    rev = "v${version}";
    hash = "sha256-lDIhI9CnWwVVGyAJAS3gDUEkeXShTvPd8JKC1j9/9yU=";
  };

  cargoHash = "sha256-3uSZtf2sbz74+V7LeHWWQWglrGRpiUSNAedVngjrH1Q=";

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
