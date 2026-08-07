{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "diskwatch";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "matthart1983";
    repo = "diskwatch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5EGNfMn//b38mhTK8rJfPJdk1rIPeijreDBkgoDmjBs=";
  };

  __structuredAttrs = true;

  cargoHash = "sha256-QCO29y4R4IRW24qJrG0vHPxHHvKHopJlMen2tBD/F5s=";

  nativeCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  versionCheckProgramArg = [ "-V" ];

  meta = {
    description = "Single-host, read-only disk diagnostics TUI";
    homepage = "https://github.com/matthart1983/diskwatch";
    changelog = "https://github.com/matthart1983/diskwatch/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "diskwatch";
  };
})
