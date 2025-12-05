{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "slumber";
  version = "4.2.1";

  src = fetchFromGitHub {
    owner = "LucasPickering";
    repo = "slumber";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8uJGNiKhK/6wdUv95PtUEa8LcgDfdGzdRSSUmB2vCiw=";
  };

  cargoHash = "sha256-IR/In6zLZAOHEC0YAulbK60SUJKWnBtesst5mnWJARI=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal-based HTTP/REST client";
    homepage = "https://slumber.lucaspickering.me";
    changelog = "https://github.com/LucasPickering/slumber/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "slumber";
    maintainers = with lib.maintainers; [ javaes ];
  };
})
