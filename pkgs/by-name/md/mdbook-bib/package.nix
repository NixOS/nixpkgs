{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mdbook-bib";
  version = "0.5.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "francisco-perez-sorrosal";
    repo = "mdbook-bib";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xgGJYnOYUuxHs2sXzYKSZd0jLm/x/PoPsNHQcWpXkn8=";
  };

  cargoHash = "sha256-QyP+Mw/95NvjaAkr5eoeC49nLXCE9/TMPIWahJayqBQ=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  meta = {
    description = "mdBook plugin for creating a bibliography & citations in your books";
    homepage = "https://github.com/francisco-perez-sorrosal/mdbook-bib";
    changelog = "https://github.com/francisco-perez-sorrosal/mdbook-bib/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ markhakansson ];
    mainProgram = "mdbook-bib";
  };
})
