{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage {
  pname = "mdbook-plantuml";
  version = "0.8.0-unstable-2022-12-28";

  src = fetchFromGitHub {
    owner = "sytsereitsma";
    repo = "mdbook-plantuml";
    rev = "c156b53aad6d7bce8479e5406a4a3465c12714ef";
    hash = "sha256-5/6NQO++MsV7GS69jGkdpkiRhadtQyYZeHreft4h6hQ=";
  };

  cargoHash = "sha256-LzzAaWLDODbqGNVeEULLOgrpyLGKzaknIbLjKyF2zBw=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  meta = {
    description = "mdBook preprocessor to render PlantUML diagrams to png images in the book output directory";
    mainProgram = "mdbook-plantuml";
    homepage = "https://github.com/sytsereitsma/mdbook-plantuml";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      jcouyang
      matthiasbeyer
    ];
  };
}
