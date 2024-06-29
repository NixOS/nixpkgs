{ php
, fetchFromGitHub
, lib
}:

(php.withExtensions ({ enabled, all }: enabled ++ [ all.pcov ])).buildComposerProject (finalAttrs: {
  pname = "paratest";
  version = "7.4.3";

  src = fetchFromGitHub {
    owner = "paratestphp";
    repo = "paratest";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Shf/fsGhDmupFn/qERzXGg3ko7mBgUqYzafO/VPqmoU=";
  };

  composerLock = ./composer.lock;
  vendorHash = "sha256-9KFh6Vwzt17v6WlEutRpwCauLOcj05hR4JGDcPbYL1U=";

  meta = {
    changelog = "https://github.com/paratestphp/paratest/releases/tag/v${finalAttrs.version}";
    description = "Parallel testing for PHPUnit";
    homepage = "https://github.com/paratestphp/paratest";
    license = lib.licenses.mit;
    mainProgram = "paratest";
    maintainers = with lib.maintainers; [ patka ];
  };
})
