{
  php,
  fetchFromGitHub,
  lib,
  versionCheckHook,
}:

(php.withExtensions ({ enabled, all }: enabled ++ [ all.pcov ])).buildComposerProject2
  (finalAttrs: {
    pname = "paratest";
    version = "7.22.3";

    src = fetchFromGitHub {
      owner = "paratestphp";
      repo = "paratest";
      tag = "v${finalAttrs.version}";
      hash = "sha256-ad3/r7ndYVl1yTZoBoBMDLI7a/FbxLugENqXH1NBDRw=";
    };

    composerLock = ./composer.lock;
    vendorHash = "sha256-o4AwINmX1lnJQmPgaQj0o++fHi0FyNNBavi1O80wfso=";

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
