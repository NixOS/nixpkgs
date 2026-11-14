{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nodejs,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "depsguard";
  version = "0.1.40";

  src = fetchFromGitHub {
    owner = "arnica";
    repo = "depsguard";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ry20L5aUzrZZYQIR1Q9Ly4Pu1dDM1hPdyCNOr6wrLlU=";
  };

  __structuredAttrs = true;

  cargoHash = "sha256-9LUbu21Uhi5vuQz+Y2vGSHCDEiOUyVCwNwlbWZaHyRQ=";

  # tests expect a package manager on PATH to report findings
  nativeCheckInputs = [
    nodejs
    writableTmpDirAsHomeHook
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Harden package manager configs against supply chain attacks";
    homepage = "https://depsguard.com";
    changelog = "https://github.com/arnica/depsguard/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jtrv ];
    mainProgram = "depsguard";
  };
})
