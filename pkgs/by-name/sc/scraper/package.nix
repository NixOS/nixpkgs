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
  version = "0.25.0";

  src = fetchFromGitHub {
    owner = "rust-scraper";
    repo = "scraper";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SGYusb+8MKz4vXjZZlM+bpmrshmts+FZLjR44DyHYqg=";
  };

  cargoHash = "sha256-vbJMOVur2QE0rFo1OJkSsuNzTOzn22ty5Py3gozDEzs=";

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
