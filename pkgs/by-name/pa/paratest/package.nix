{
  php,
  fetchFromGitHub,
  lib,
  versionCheckHook,
}:

(php.withExtensions ({ enabled, all }: enabled ++ [ all.pcov ])).buildComposerProject2
  (finalAttrs: {
    pname = "paratest";
    version = "7.24.1";

    src = fetchFromGitHub {
      owner = "paratestphp";
      repo = "paratest";
      tag = "v${finalAttrs.version}";
      hash = "sha256-wNdZyZ7r9UpXCJwE4yucEg9FmWCy06HRr56s1XZQWB0=";
    };

    composerLock = ./composer.lock;
    vendorHash = "sha256-LomuNhr/g9Fa6du0xPcRHPSEXDLRcbqEOqha9wwtY7M=";

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
