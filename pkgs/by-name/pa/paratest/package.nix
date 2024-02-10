{ php
, fetchFromGitHub
, lib
}:

(php.withExtensions ({ enabled, all }: enabled ++ [ all.pcov ])).buildComposerProject (finalAttrs: {
  pname = "paratest";
  version = "7.4.1";

  src = fetchFromGitHub {
    owner = "paratestphp";
    repo = "paratest";
    rev = "v${finalAttrs.version}";
    hash = "sha256-0cyv2WSiGjyp9vv2J8hxFnuvxAwrig1DmSxKSdBzNGI=";
  };

  composerLock = ./composer.lock;
  vendorHash = "sha256-vYcfmVEMGhAvPYTsVAJl7njxgVkL1b8QBr/3/DCxmCE=";

  meta = {
    changelog = "https://github.com/paratestphp/paratest/releases/tag/v${finalAttrs.version}";
    description = "Parallel testing for PHPUnit";
    homepage = "https://github.com/paratestphp/paratest";
    license = lib.licenses.mit;
    mainProgram = "paratest";
    maintainers = with lib.maintainers; [ patka ];
  };
})
