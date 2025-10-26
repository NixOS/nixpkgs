{
  lib,
  rustPlatform,
  fetchCrate,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "scraper";
  version = "0.24.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-/WdzwqwxTZiWyLV/W0nsMgVJ+o3wJU6u0gOMZva+WSM=";
  };

  cargoHash = "sha256-0k8tYJbsWRAWn7stsodC8qkzzl3O8AZ1QrQ7i/n2YzY=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage scraper.1
  '';

  meta = {
    description = "Tool to query HTML files with CSS selectors";
    mainProgram = "scraper";
    homepage = "https://github.com/causal-agent/scraper";
    changelog = "https://github.com/causal-agent/scraper/releases/tag/v${version}";
    license = lib.licenses.isc;
    maintainers = [ ];
  };
}
