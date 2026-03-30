{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "bine";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "hymkor";
    repo = "bine";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FhwceePOsppyj7CzApIzpjWVB8iciWOYXVZNRoZhe9E=";
  };

  vendorHash = "sha256-j8M/gBIFeow+RJjh5ZDXVNnkbJ+qbIZ5XeW+06yiWTM=";

  __structuredAttrs = true;

  ldflags = [ "-s" ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/hymkor/bine/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Fast terminal hex editor for large files and pipelines";
    homepage = "https://github.com/hymkor/bine";
    license = lib.licenses.mit;
    mainProgram = "bine";
    maintainers = with lib.maintainers; [ yiyu ];
  };
})
