{ lib, rustPlatform, fetchCrate, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "scraper";
  version = "0.22.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-YefezVG/p+nhdJu5YetR84yL9H7Iqz/k+Hnp8Bwv7gI=";
  };

  cargoHash = "sha256-ER47QAqPLUbbb92sBsPMGr/XPQXmVSNTVYx2UMrOeJo=";

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
