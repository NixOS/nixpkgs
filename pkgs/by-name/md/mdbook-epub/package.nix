{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  bzip2,
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-epub";
  version = "0.4.37";

  src = fetchFromGitHub {
    owner = "michael-f-bryan";
    repo = "mdbook-epub";
    tag = version;
    hash = "sha256-ddWClkeGabvqteVUtuwy4pWZGnarrKrIbuPEe62m6es=";
  };

  cargoHash = "sha256-3R81PJCOFc22QDHH2BqGB9jjvEcMc1axoySSJLJD3wI=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ bzip2 ];

  meta = {
    description = "mdbook backend for generating an e-book in the EPUB format";
    mainProgram = "mdbook-epub";
    homepage = "https://michael-f-bryan.github.io/mdbook-epub";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      matthiasbeyer
    ];
  };
}
