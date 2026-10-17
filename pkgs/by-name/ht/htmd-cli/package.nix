{
  fetchFromGitHub,
  lib,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "htmd-cli";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "letmutex";
    repo = "htmd-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-csc/uAbxFWYohTspWxAEuPDD9RXbknSa0P4PlM6ioX0=";
  };

  cargoHash = "sha256-Qt6OIorUwXttHajI5pjGjoAl0sENNCR8B2YHpcgxssE=";

  passthru.updateScript = nix-update-script { };

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  __structuredAttrs = true;

  meta = {
    description = "The command line tool for htmd, an HTML to Markdown converter";
    homepage = "https://github.com/letmutex/htmd-cli";
    changelog = "https://github.com/letmutex/htmd-cli/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ drawbu ];
    mainProgram = "htmd";
  };
})
