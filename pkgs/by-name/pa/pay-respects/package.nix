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
  version = "0.6.13";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "iff";
    repo = "pay-respects";
    rev = "v${version}";
    hash = "sha256-uiNGx0+tN75pGZy3kW0ibZfjT9Cs+P2M5fT5CtFwJDo=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-ItXWks18xxb+bP35hBdB3UL5TNSo4vCc/Tm4+EX8NUs=";

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
