{ php, fetchFromGitHub, lib }:

let
  phpPackage = php.withExtensions ({ enabled, all }: enabled ++ [ all.pcov ]);
in php.buildComposerProject (finalAttrs: {
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

  php = phpPackage;

  meta = {
    changelog = "https://github.com/paratestphp/paratest/releases/tag/v${finalAttrs.version}";
    description = "Parallel testing for PHPUnit";
    homepage = "https://github.com/paratestphp/paratest";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ patka ];
  };
})
