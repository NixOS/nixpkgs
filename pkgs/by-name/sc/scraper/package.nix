{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "scraper";
  version = "0.24.0";

  src = fetchFromGitHub {
    owner = "rust-scraper";
    repo = "scraper";
    tag = "v${finalAttrs.version}";
    hash = "sha256-T4a5eRWapDPctF8Nc2kIlgJGTckqlvt2ujARsNZH06k=";
  };

  cargoHash = "sha256-0k8tYJbsWRAWn7stsodC8qkzzl3O8AZ1QrQ7i/n2YzY=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage scraper/scraper.1
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Tool to query HTML files with CSS selectors";
    mainProgram = "scraper";
    homepage = "https://github.com/rust-scraper/scraper";
    changelog = "https://github.com/rust-scraper/scraper/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.isc;
    maintainers = [ ];
  };
})
