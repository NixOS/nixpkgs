{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-kroki-preprocessor";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "joelcourtney";
    repo = "mdbook-kroki-preprocessor";
    rev = "v${version}";
    hash = "sha256-rTXieHa/EIg69vUQE2FOD1Xb4cUVe5CvBiv9CnhHB3I=";
  };

  cargoHash = "sha256-aTtjrCl13oOKqwPGiVlOfjGqAdBS94XGjcvn3bBWpa0=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  meta = with lib; {
    description = "Render Kroki diagrams from files or code blocks in mdbook";
    mainProgram = "mdbook-kroki-preprocessor";
    homepage = "https://github.com/joelcourtney/mdbook-kroki-preprocessor";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      matthiasbeyer
    ];
  };
}
