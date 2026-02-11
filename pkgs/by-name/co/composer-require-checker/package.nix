{
  lib,
  fetchgit,
  php,
  versionCheckHook,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "composer-require-checker";
  version = "4.20.0";

  # Upstream no longer provides the composer.lock in their release artifact
  src = fetchgit {
    url = "https://github.com/maglnet/ComposerRequireChecker";
    tag = finalAttrs.version;
    hash = "sha256-60LbfzOlroJuesLnPe674COXSnNQMDXc2zI3fWbEltM=";
  };

  vendorHash = "sha256-4kHp7d0+6r/wr2M+lz45ujhGIEVpQPQCUTzhurJ6YEw=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "CLI tool to check whether a specific composer package uses imported symbols that aren't part of its direct composer dependencies";
    homepage = "https://github.com/maglnet/ComposerRequireChecker/";
    changelog = "https://github.com/maglnet/ComposerRequireChecker/releases/tag/${finalAttrs.version}";
    license = with lib.licenses; [ mit ];
    mainProgram = "composer-require-checker";
    maintainers = [ lib.maintainers.patka ];
  };
})
