{
  lib,
  fetchFromGitHub,
  php83,
  versionCheckHook,
}:

php83.buildComposerProject2 (finalAttrs: {
  pname = "n98-magerun2";
  version = "9.1.0";

  src = fetchFromGitHub {
    owner = "netz98";
    repo = "n98-magerun2";
    tag = finalAttrs.version;
    hash = "sha256-kjT72pLKuN166Edm8+8vUIfhFdMnZkeTagl0ECL20b8=";
  };

  vendorHash = "sha256-wqaePPMC1OiXwtdhMJzg4AvcYDmJg2Uo2LV7TbZ00ec=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    changelog = "https://magerun.net/category/magerun/";
    description = "Swiss army knife for Magento2 developers";
    homepage = "https://magerun.net/";
    license = lib.licenses.mit;
    mainProgram = "n98-magerun2";
    teams = [ lib.teams.php ];
  };
})
