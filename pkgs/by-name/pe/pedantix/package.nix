{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pedantix";
  version = "1.2.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Swarsel";
    repo = "pedantix";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WqCiIOFaVZ6+pVBF+fIZlOEb4N+cHCJZBPQ8Rj2OEh0=";
  };

  cargoHash = "sha256-ay4rANqOby+/VM+JWbXcd0JQCcZuv8TjZv3d9vcFgfI=";

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
