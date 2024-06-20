{ lib
, fetchFromGitHub
, php
}:

php.buildComposerProject (finalAttrs: {
  pname = "phpbench";
  version = "1.2.14";

  src = fetchFromGitHub {
    owner = "phpbench";
    repo = "phpbench";
    rev = finalAttrs.version;
    hash = "sha256-T89r/9doy3JxvVQI/sAwKF1ndWEytGaz2BG6ORnefMw=";
  };

  # TODO: Open a PR against https://github.com/phpbench/phpbench
  # Missing `composer.lock` from the repository.
  composerLock = ./composer.lock;
  vendorHash = "sha256-wA1V1jBsNaSYVkMtoUivbZTXHXafvMgEEtccCThTk3o=";

  meta = {
    changelog = "https://github.com/phpbench/phpbench/blob/${finalAttrs.version}/CHANGELOG.md";
    description = "PHP Benchmarking framework";
    homepage = "https://github.com/phpbench/phpbench";
    license = lib.licenses.gpl2;
    mainProgram = "phpbench";
    maintainers = with lib.maintainers; [ drupol ];
  };
})
