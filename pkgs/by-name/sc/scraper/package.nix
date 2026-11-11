{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "scraper";
  version = "0.29.0";

  src = fetchFromGitHub {
    owner = "rust-scraper";
    repo = "scraper";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LEmoVYk93J309d0ThBvycSbzhIX25YVAY/HMoC09qM4=";
  };

  cargoHash = "sha256-DXKXAvtjILlk5C14EjSZpgGPV0Hltg+KE1GAb1OYgao=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage scraper/scraper.1
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Tool to query HTML files with CSS selectors";
    mainProgram = "scraper";
    homepage = "https://github.com/rust-scraper/scraper";
    changelog = "https://github.com/rust-scraper/scraper/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [
      kachick
    ];
  };
})
