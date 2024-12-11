{ lib, rustPlatform, fetchCrate, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "scraper";
  version = "0.21.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-S9bVsLDAX7UJ9FV4ZuI1G1D2fSZSZsevtftr7y+HyI8=";
  };

  cargoHash = "sha256-K4ZmarOniI7OgzjkaP66Py5ei+NKeJEOuziS//NXffw=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage scraper.1
  '';

  meta = with lib; {
    description = "Tool to query HTML files with CSS selectors";
    mainProgram = "scraper";
    homepage = "https://github.com/causal-agent/scraper";
    changelog = "https://github.com/causal-agent/scraper/releases/tag/v${version}";
    license = licenses.isc;
    maintainers = with maintainers; [ figsoda ];
  };
}
