{ lib
, fetchFromGitHub
, php
}:

php.buildComposerProject (finalAttrs: {
  pname = "gdpr-dump";
  version = "4.0.3";

  src = fetchFromGitHub {
    owner = "Smile-SA";
    repo = "gdpr-dump";
    rev = finalAttrs.version;
    hash = "sha256-OCM4Lj5v6tKdxHCoFLbGuNQ2tHSn0sRJBk8Bw87fqrQ=";
  };

  postPatch = ''
    substituteInPlace src/Console/Application.php \
      --replace-fail "VERSION = 'dev'" "VERSION = '${finalAttrs.version}'"
  '';

  composerLock = ./composer.lock;
  vendorHash = "sha256-nTgsAffo/ynbcD7x16s4HadoPyVXb11zT1DA/wJlTDo=";

  meta = {
    changelog = "https://github.com/Smile-SA/gdpr-dump/releases/tag/${finalAttrs.version}";
    description = "Utility that creates anonymized database dumps (MySQL only). Provides default config templates for Magento, Drupal and Shopware";
    homepage = "https://github.com/Smile-SA/gdpr-dump";
    license = lib.licenses.gpl3;
    mainProgram = "gdpr-dump";
    maintainers = lib.teams.php.members;
  };
})
