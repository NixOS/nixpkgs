{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mcat-unwrapped";
  version = "0.2.8";

  src = fetchFromGitHub {
    owner = "Skardyy";
    repo = "mcat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XvZBikp+Q/pe80eOTQj2rKZ14kXEUBjIroWsh8xmr8A=";
  };

  cargoHash = "sha256-DIvKCPyqD82IgOqs7+fsAz3sj5IkXacxfZOttSEQ1aA=";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "cat command for documents / images / videos and more!";
    homepage = "https://github.com/Skardyy/mcat";
    changelog = "https://github.com/Skardyy/mcat/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "mcat";
    maintainers = with lib.maintainers; [
      louis-thevenet
    ];
  };
})
