{
  lib,
  php,
  fetchFromGitHub,
  makeBinaryWrapper,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "phpdocumentor";
  version = "3.6.0";

  src = fetchFromGitHub {
    owner = "phpDocumentor";
    repo = "phpDocumentor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8TQlqXhZ3rHmOAuxsBYa+7JD+SxMQY0NZgCyElStFag=";
  };

  vendorHash = "sha256-PVaa0o8daoqXs8l3bF/Fsmtx3bdpO2uXTnR4tx8cUC4=";

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
