{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "glim";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "junkdog";
    repo = "glim";
    tag = "glim-v${finalAttrs.version}";
    hash = "sha256-m5ZHXEu06kyCGqHBvcBgdgbi6gjHtegWrE1tDnMHyFg=";
  };

  cargoHash = "sha256-4NJtGqKOUWyv1ZcrQqqZgGI8vzSZpRfcVJWI7TKZCi8=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  __darwinAllowLocalNetworking = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "TUI for monitoring GitLab CI/CD pipelines and projects";
    homepage = "https://github.com/junkdog/glim";
    changelog = "https://github.com/junkdog/glim/releases/tag/glim-v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "glim";
  };
})
