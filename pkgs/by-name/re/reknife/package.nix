{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "reknife";
  version = "1.8.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "bl4ckr0ss3";
    repo = "knife";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oloigIVxFpi3DEK4FaAEOzNeho/xWb/NU44Zez/eMmQ=";
  };

  cargoHash = "sha256-eIK4PyzdGV8TSvKa1XUVbtHWU7ZlPMiba/N0DYu7ps8=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool for reverse engineering binaries";
    homepage = "https://github.com/bl4ckr0ss3/knife";
    changelog = "https://github.com/bl4ckr0ss3/knife/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "knife";
  };
})
