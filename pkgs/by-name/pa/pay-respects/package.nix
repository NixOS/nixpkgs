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
  version = "0.7.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "iff";
    repo = "pay-respects";
    rev = "v${version}";
    hash = "sha256-xuZkZXVEXSmRGp1huVpqvjrP5kllq3fGg1Mg7wuyE3E=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-aocFplTvjc3zV6NL6UKzdfdx5ry+jhvi4azceC0KSKA=";

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
