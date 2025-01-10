{
  lib,
  php,
  fetchFromGitHub,
  makeBinaryWrapper,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "phpdocumentor";
  version = "3.5.3";

  src = fetchFromGitHub {
    owner = "phpDocumentor";
    repo = "phpDocumentor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zpAKygpxyKYfefa5ag76saTSQNLon/v3rYkl0Nj2+FM=";
  };

  vendorHash = "sha256-whyLSlv0s7v+oi+0Qv8tBxUzYrUOARUjKZiNTfIqoTU=";

  # Needed because of the unbound version constraint on phpdocumentor/json-path
  composerStrictValidation = false;

  nativeBuildInputs = [ makeBinaryWrapper ];

  postInstall = ''
    wrapProgram "$out/bin/phpdoc" \
      --set-default APP_CACHE_DIR /tmp \
      --set-default APP_LOG_DIR /tmp/log
  '';

  meta = {
    changelog = "https://github.com/phpDocumentor/phpDocumentor/releases/tag/v${finalAttrs.version}";
    description = "PHP documentation generator";
    homepage = "https://phpdoc.org";
    license = lib.licenses.mit;
    mainProgram = "phpdoc";
    maintainers = with lib.maintainers; [ drupol ];
  };
})
