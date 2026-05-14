{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "similarity";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "mizchi";
    repo = "similarity";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xYA1o4nmZLo0TY56KOtm2eTR9xL4/uEVTKmFaQT+kCQ=";
  };

  cargoHash = "sha256-r/9Yq1h8i7OWMicK9z36TzUTQRDOk6cND+5RvL045yA=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/similarity-ts";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Code similarity detection tool";
    homepage = "https://github.com/mizchi/similarity";
    changelog = "https://github.com/mizchi/similarity/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ airrnot ];
  };
})
