{
  lib,
  fetchgit,
  php,
  versionCheckHook,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "composer-require-checker";
  version = "4.16.1";

  # Upstream no longer provides the composer.lock in their release artifact
  src = fetchgit {
    url = "https://github.com/maglnet/ComposerRequireChecker";
    tag = finalAttrs.version;
    hash = "sha256-UAofdc8mqSnJXhCTABSf9JZERqur86lzNDI66EHgEQE=";
  };

  vendorHash = "sha256-bNeQEfwXly3LFuEKeSK6J6pRfQF6TNwUqu3SdTswmFI=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  meta = {
    description = "CLI tool to check whether a specific composer package uses imported symbols that aren't part of its direct composer dependencies";
    homepage = "https://github.com/maglnet/ComposerRequireChecker/";
    changelog = "https://github.com/maglnet/ComposerRequireChecker/releases/tag/${finalAttrs.version}";
    license = with lib.licenses; [ mit ];
    mainProgram = "composer-require-checker";
    maintainers = [ lib.maintainers.patka ];
  };
})
