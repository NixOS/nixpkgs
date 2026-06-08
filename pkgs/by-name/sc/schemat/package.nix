{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "schemat";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "raviqqe";
    repo = "schemat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ij7JigbXhE2o0Z61uZ3W/pK7zcQyrX+SMpF0iKsVx30=";
  };

  cargoHash = "sha256-oaET2IGU78TUC98HKsiQnbg7R262ugrn8oiLeKC767s=";

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
