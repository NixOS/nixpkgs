{
  php,
  fetchFromGitHub,
  lib,
  versionCheckHook,
}:

(php.withExtensions ({ enabled, all }: enabled ++ [ all.pcov ])).buildComposerProject2
  (finalAttrs: {
    pname = "paratest";
    version = "7.25.0";

    src = fetchFromGitHub {
      owner = "paratestphp";
      repo = "paratest";
      tag = "v${finalAttrs.version}";
      hash = "sha256-rvxDqtcZ6KbhjX5rBkiPn1FxqT1s+YtYfIwhMyTTTZU=";
    };

    composerLock = ./composer.lock;
    vendorHash = "sha256-bszTB7FcalfGLywtjn4qt2kBBDqyESUc/a20IfMpQ6Y=";

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
