{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pedantix";
  version = "1.1.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Swarsel";
    repo = "pedantix";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6NwpoqHkMMnqDkoJGbjZ47PUx+M4yYDcN5HiTKscw7E=";
  };

  cargoHash = "sha256-6U9rnWTVsO1DPp1cEBkRLHjJKcbgNEqXSvzWUC8tWZQ=";

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
