{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-kroki-preprocessor";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "joelcourtney";
    repo = "mdbook-kroki-preprocessor";
    rev = "v${version}";
    hash = "sha256-3BxIhJK0YWZBEbbNwMKixo1icEn+QKJwoskgIEaZcGQ=";
  };

  cargoHash = "sha256-vOP/XvoHwJd34f+NGGCFJkEbefbbJjFcGTOFaCn9dj8=";

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
