{
  lib,
  fetchgit,
  php,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "composer-require-checker";
  version = "4.14.0";

  # Upstream no longer provides the composer.lock in their release artifact
  src = fetchgit {
    url = "https://github.com/maglnet/ComposerRequireChecker";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-dBUDkgbuUBKA3MKB4fxwHhDoT9wYRl49m/2ZCvIcNMM=";
  };

  vendorHash = "sha256-JNdSek3f3WEtJQHjSV+HF6b8l9eZvbI0n4g3UUUVja4=";

  meta = {
    description = "CLI tool to check whether a specific composer package uses imported symbols that aren't part of its direct composer dependencies";
    homepage = "https://github.com/maglnet/ComposerRequireChecker/";
    changelog = "https://github.com/maglnet/ComposerRequireChecker/releases/tag/${finalAttrs.version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "composer-require-checker";
  };
})
