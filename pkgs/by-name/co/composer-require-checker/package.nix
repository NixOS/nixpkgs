{
  lib,
  fetchgit,
  php,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "composer-require-checker";
  version = "4.13.0";

  # Upstream no longer provides the composer.lock in their release artifact
  src = fetchgit {
    url = "https://github.com/maglnet/ComposerRequireChecker";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-xq8W5SXwtmJ3uu5g26/rxL02jqBuxvEEQpwazPdCE5Y=";
  };

  vendorHash = "sha256-GGT/9kBpd7PU/pMJFWw1rrEW2QFUlrp3lljUCyo+/bw=";

  meta = {
    description = "CLI tool to check whether a specific composer package uses imported symbols that aren't part of its direct composer dependencies";
    homepage = "https://github.com/maglnet/ComposerRequireChecker/";
    changelog = "https://github.com/maglnet/ComposerRequireChecker/releases/tag/${finalAttrs.version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "composer-require-checker";
  };
})
