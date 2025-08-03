{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pyrefly";
  version = "0.20.2";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "pyrefly";
    tag = finalAttrs.version;
    hash = "sha256-E3CPs3/c5/0VKeRFI6dNRj0xUoU9YBV1rZ1qFt4E2+U=";
  };

  buildAndTestSubdir = "pyrefly";
  cargoHash = "sha256-EkGw7y5NtJ6Yd3DzL4z+81I0v5WyIwZ28klHXMqHjJc=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  # requires unstable rust features
  env.RUSTC_BOOTSTRAP = 1;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast type checker and IDE for Python";
    homepage = "https://github.com/facebook/pyrefly";
    license = lib.licenses.mit;
    mainProgram = "pyrefly";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [
      cybardev
      QuiNzX
    ];
  };
})
