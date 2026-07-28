{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nxv";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "utensils";
    repo = "nxv";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2B3J+jrZZUF1CE/chdSXNO6IAuruXfRUd6pG8dyWjpQ=";
  };

  cargoHash = "sha256-1WiG2jIVPf0ess3oLbpPvaYSRzvwEJDe9BKaEWWptGE=";

  # Tests use mockito which needs to bind to localhost
  __darwinAllowLocalNetworking = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Find any version of any Nix package instantly";
    longDescription = ''
      nxv indexes nixpkgs channel releases (2016+) to help you discover
      when packages were added, which versions existed, and the exact
      commit to use with `nix shell nixpkgs/<commit>#package`.
    '';
    homepage = "https://nxv.urandom.io";
    changelog = "https://github.com/utensils/nxv/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      yiyu
      jamesbrink
    ];
    mainProgram = "nxv";
  };
})
