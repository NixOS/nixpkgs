{ lib
, php
, fetchFromGitHub
}:

php.buildComposerProject (finalAttrs: {
  pname = "phpdocumentor";
  version = "3.4.3";

  src = fetchFromGitHub {
    owner = "phpDocumentor";
    repo = "phpDocumentor";
    rev = "v${finalAttrs.version}";
    hash = "sha256-NCBCwQ8im6ttFuQBaG+bzmtinf+rqNnbogcK8r60dCM=";
  };

  vendorHash = "sha256-/TJ/CahmOWcRBlAsJDzWcfhlDd+ypRapruFT0Dvlb1w=";

  # Needed because of the unbound version constraint on phpdocumentor/json-path
  composerStrictValidation = false;

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
