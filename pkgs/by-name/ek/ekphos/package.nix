{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ekphos";
  version = "0.20.10";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "hanebox";
    repo = "ekphos";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mZ6yQdPpJ9PglYyHwivVDO05vRPvwZG7DPEBJeOVlFE=";
  };

  cargoHash = "sha256-s6Elg0Fqxdlc2/428oV7POMqphx8vWaLOncO5kZyBfQ=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Lightweight, fast, terminal-based markdown research tool inspired by Obsidian";
    homepage = "https://ekphos.netlify.app/docs";
    downloadPage = "https://github.com/hanebox/ekphos";
    changelog = "https://github.com/hanebox/ekphos/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "ekphos";
  };
})
