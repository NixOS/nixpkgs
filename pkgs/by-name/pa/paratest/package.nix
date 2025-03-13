{
  php,
  fetchFromGitHub,
  lib,
  versionCheckHook,
}:

(php.withExtensions ({ enabled, all }: enabled ++ [ all.pcov ])).buildComposerProject2
  (finalAttrs: {
    pname = "paratest";
    version = "7.8.2";

    src = fetchFromGitHub {
      owner = "paratestphp";
      repo = "paratest";
      tag = "v${finalAttrs.version}";
      hash = "sha256-OCZOpCjFORk5ZcImM8mArQSgK9MLneTC6TxGTNPqvWk=";
    };

    composerLock = ./composer.lock;
    vendorHash = "sha256-c2bBhJ9NvNk7Cz5RmNfgN2Q9SUV0iZ3/IhvzuAJtlQk=";

    nativeInstallCheckInputs = [
      versionCheckHook
    ];
    versionCheckProgramArg = [ "--version" ];
    doInstallCheck = true;

    meta = {
      changelog = "https://github.com/paratestphp/paratest/releases/tag/v${finalAttrs.version}";
      description = "Parallel testing for PHPUnit";
      homepage = "https://github.com/paratestphp/paratest";
      license = lib.licenses.mit;
      mainProgram = "paratest";
      maintainers = lib.teams.php.members;
    };
  })
