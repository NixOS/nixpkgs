{
  php,
  fetchFromGitHub,
  lib,
}:

(php.withExtensions ({ enabled, all }: enabled ++ [ all.pcov ])).buildComposerProject2
  (finalAttrs: {
    pname = "paratest";
    version = "7.6.0";

    src = fetchFromGitHub {
      owner = "paratestphp";
      repo = "paratest";
      rev = "v${finalAttrs.version}";
      hash = "sha256-p7m/MDHy+NOh+MnoIWy74Ipm/5hevp4x6Qwn4uPIEAM=";
    };

    composerLock = ./composer.lock;
    vendorHash = "sha256-NQWwfSYgvAmvWnr563vAKh+IdFRDB/CJZReDUzftOvw=";

    meta = {
      changelog = "https://github.com/paratestphp/paratest/releases/tag/v${finalAttrs.version}";
      description = "Parallel testing for PHPUnit";
      homepage = "https://github.com/paratestphp/paratest";
      license = lib.licenses.mit;
      mainProgram = "paratest";
      maintainers = [ ];
    };
  })
