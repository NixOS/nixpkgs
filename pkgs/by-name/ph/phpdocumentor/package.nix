{ lib
, php
, fetchFromGitHub
}:

php.buildComposerProject (finalAttrs: {
  pname = "phpdocumentor";
  version = "3.4.1";

  src = fetchFromGitHub {
    owner = "phpDocumentor";
    repo = "phpDocumentor";
    rev = "v${finalAttrs.version}";
    hash = "sha256-fNjix3pJDRCTWM3Xtn+AtZe4RJfgQ60kiJB9J9tC5t4=";
  };

  vendorHash = "sha256-rsBg2EHbvYLVr6haN1brHZFVjLDaxqdkNWf0HL3Eoy0=";

  installPhase = ''
    runHook preInstall

    wrapProgram "$out/bin/phpdoc" \
      --set-default APP_CACHE_DIR /tmp \
      --set-default APP_LOG_DIR /tmp/log

    runHook postInstall
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
