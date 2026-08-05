{
  php,
  fetchFromGitHub,
  lib,
  versionCheckHook,
}:

(php.withExtensions ({ enabled, all }: enabled ++ [ all.pcov ])).buildComposerProject2
  (finalAttrs: {
    pname = "paratest";
    version = "7.23.1";

    src = fetchFromGitHub {
      owner = "paratestphp";
      repo = "paratest";
      tag = "v${finalAttrs.version}";
      hash = "sha256-qHsO+ksD6CcfGChIu/y9uPAK4fNtWljZtRLHYVTOgQo=";
    };

    composerLock = ./composer.lock;
    vendorHash = "sha256-IJsnaIJnKeLSL5iO6aJYLCDH5heZhCD+8ZmFhUP5HA0=";

    passthru.updateScript = ./update.sh;

    nativeInstallCheckInputs = [
      versionCheckHook
    ];
    doInstallCheck = true;

    meta = {
      changelog = "https://github.com/paratestphp/paratest/releases/tag/v${finalAttrs.version}";
      description = "Parallel testing for PHPUnit";
      homepage = "https://github.com/paratestphp/paratest";
      license = lib.licenses.mit;
      mainProgram = "paratest";
      maintainers = [
        lib.maintainers.patka
        lib.maintainers.piotrkwiecinski
      ];
    };
  })
