{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nxv";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "jamesbrink";
    repo = "nxv";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Gj+5Tgt0IO2P/GyPVM9yBgYoiSkpdfcq1r8TmZLZMSs=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-7c1LryJvrOsSiLPYNvGIFaTONhA0c99n918/yNRKkxo=";

  # Tests use mockito which needs to bind to localhost
  __darwinAllowLocalNetworking = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Find any version of any Nix package instantly";
    longDescription = ''
      nxv indexes the entire nixpkgs git history to help you discover
      when packages were added, which versions existed, and the exact
      commit to use with `nix shell nixpkgs/<commit>#package`.
    '';
    homepage = "https://nxv.urandom.io";
    changelog = "https://github.com/jamesbrink/nxv/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "nxv";
  };
})
