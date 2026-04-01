{
  lib,
  fetchCrate,
  rustPlatform,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mdbook-bib";
  version = "0.5.2";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-tXzecypo5lck2o7qHkj0YNyMHneR/2wMnFjNHOQJMgw=";
  };

  cargoHash = "sha256-QyP+Mw/95NvjaAkr5eoeC49nLXCE9/TMPIWahJayqBQ=";
  cargoDepsName = finalAttrs.pname;

  meta = {
    description = "mdBook plugin for creating a bibliography & citations in your books";
    mainProgram = "mdbook-bib";
    homepage = "https://github.com/francisco-perez-sorrosal/mdbook-bib";
    changelog = "https://github.com/francisco-perez-sorrosal/mdbook-bib/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ markhakansson ];
  };
})
