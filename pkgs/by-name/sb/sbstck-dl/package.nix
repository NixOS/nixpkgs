{
  lib,
  buildGoLatestModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoLatestModule (finalAttrs: {
  pname = "sbstck-dl";
  version = "0.10.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "alexferrari88";
    repo = "sbstck-dl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lIC7AGfHe/49fuls4aNXYQ/tYtdeG9jv7+kqsdHsWz4=";
  };

  vendorHash = "sha256-cc92Q6HxZkjqwK/iYdrvfM+AKM4gLVQ197wlaR2H6rc=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI tool for downloading Substack newsletters for archival purposes, offline reading, or data analysis";
    homepage = "https://github.com/alexferrari88/sbstck-dl";
    changelog = "https://github.com/alexferrari88/sbstck-dl/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ io12 ];
    mainProgram = "sbstck-dl";
  };
})
