{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "schemat";
  version = "0.5.8";

  src = fetchFromGitHub {
    owner = "raviqqe";
    repo = "schemat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-stYa0gQUDAZBQhJNoxJW8c227Uord1U+elcZQiE0F74=";
  };

  cargoHash = "sha256-5J2e26t6r6/KdQSbYXjj6U3uVCc0/w+GD3P2qL8gGp8=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Code formatter for Scheme, Lisp, and any S-expressions";
    homepage = "https://github.com/raviqqe/schemat";
    changelog = "https://github.com/raviqqe/schemat/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ bddvlpr ];
    mainProgram = "schemat";
  };
})
