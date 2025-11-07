{
  php,
  fetchFromGitHub,
  lib,
  versionCheckHook,
}:

(php.withExtensions ({ enabled, all }: enabled ++ [ all.pcov ])).buildComposerProject2
  (finalAttrs: {
    pname = "paratest";
    version = "7.13.0";

    src = fetchFromGitHub {
      owner = "paratestphp";
      repo = "paratest";
      tag = "v${finalAttrs.version}";
      hash = "sha256-X4sgMxRiuAk/YkOcUOnanUsdCFp0RHUIuv2OCqP5Z3w=";
    };

    composerLock = ./composer.lock;
    vendorHash = "sha256-6fF9YbHoU1+YbSuTKXGmJqkoxdyK30YOv7gZKJVfoas=";

    nativeInstallCheckInputs = [
      versionCheckHook
    ];
    versionCheckProgramArg = "--version";
    doInstallCheck = true;

    meta = {
      changelog = "https://github.com/paratestphp/paratest/releases/tag/v${finalAttrs.version}";
      description = "Parallel testing for PHPUnit";
      homepage = "https://github.com/paratestphp/paratest";
      license = lib.licenses.mit;
      mainProgram = "paratest";
      maintainers = [ lib.maintainers.patka ];
    };
  })
