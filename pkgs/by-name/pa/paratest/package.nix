{
  php,
  fetchFromGitHub,
  lib,
  versionCheckHook,
}:

(php.withExtensions ({ enabled, all }: enabled ++ [ all.pcov ])).buildComposerProject2
  (finalAttrs: {
    pname = "paratest";
    version = "7.22.2";

    src = fetchFromGitHub {
      owner = "paratestphp";
      repo = "paratest";
      tag = "v${finalAttrs.version}";
      hash = "sha256-3QgWB9iyUasRCX8RD8rQ48Te7v61e9YDqyznXo6zz+U=";
    };

    composerLock = ./composer.lock;
    vendorHash = "sha256-7fbi0KPT+KXO9vlMIb79QKIg5JRFOcuUYtf6jJ/yqBo=";

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
