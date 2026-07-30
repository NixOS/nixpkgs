{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "stakk";
  version = "1.17.1";

  src = fetchFromGitHub {
    owner = "glennib";
    repo = "stakk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5wEZOxXg30F0MqeszDRYrOBnsOzfXxld8iQkZSPqUIY=";
  };

  cargoHash = "sha256-iEGrGSia/Da1bpXVAOI9M7QNNVHUAB/RFRgzl+IrFlU=";

  useNextest = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };
  __structuredAttrs = true;

  meta = {
    description = "Bridge Jujutsu (jj) bookmarks to GitHub stacked pull requests";
    homepage = "https://github.com/glennib/stakk";
    changelog = "https://github.com/glennib/stakk/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [
      voidlily
      Br1ght0ne
    ];
    mainProgram = "stakk";
  };
})
