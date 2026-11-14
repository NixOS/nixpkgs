{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "schemat";
  version = "0.5.14";

  src = fetchFromGitHub {
    owner = "raviqqe";
    repo = "schemat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DxRm9lfBMw6yj4eU2SW5WUnNZ7BNUHgfQx0xXWr0XwA=";
  };

  cargoHash = "sha256-x2QOt/rsFcRz1nNle+qcxOx1UN7fzXhohQ6cpWJMvcw=";

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
