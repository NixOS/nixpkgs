{
  lib,
  fetchgit,
  php,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "composer-require-checker";
  version = "4.15.0";

  # Upstream no longer provides the composer.lock in their release artifact
  src = fetchgit {
    url = "https://github.com/maglnet/ComposerRequireChecker";
    tag = finalAttrs.version;
    hash = "sha256-ku4IXiUNFfTie+umVOWx8v5vcmO51uRM/n7XN50cSjE=";
  };

  vendorHash = "sha256-AdRnqecNoDteuhGp/gWCg/xKxBRnv8I2FkuJYs4WslE=";

  meta = {
    description = "CLI tool to check whether a specific composer package uses imported symbols that aren't part of its direct composer dependencies";
    homepage = "https://github.com/maglnet/ComposerRequireChecker/";
    changelog = "https://github.com/maglnet/ComposerRequireChecker/releases/tag/${finalAttrs.version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "composer-require-checker";
  };
})
