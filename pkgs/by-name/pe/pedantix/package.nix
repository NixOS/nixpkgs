{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pedantix";
  version = "1.0.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Swarsel";
    repo = "pedantix";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ibouDGnFOfkeUvM9oOL+0a9T93jSKqUfWCGY8CfpkTg=";
  };

  cargoHash = "sha256-PwmWZEPQFknvBnK/Rtt9gl4wWq8c6hjfrcMfbhqldKw=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "The pedantic nix formatter";
    homepage = "https://github.com/Swarsel/pedantix";
    changelog = "https://github.com/Swarsel/pedantix/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ swarsel ];
    mainProgram = "pedantix";
  };
})
