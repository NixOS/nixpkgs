{
  lib,
  php,
  fetchFromGitHub,
}:
php.buildComposerProject2 (finalAttrs: {
  pname = "civicrm-core";
  version = "6.19.1";
  __structuredAttrs = true;
  strictDeps = true;
  dontUnpack = false;

  src = fetchFromGitHub {
    owner = "civicrm";
    repo = "civicrm-core";
    tag = finalAttrs.version;
    hash = "sha256-kk2q9aHP2XGcZGkNbsWsVEvAoS24AEKPzS9K9jY5taM=";
  };

  vendorHash = "sha256-t4JgbHhZIEGVyzvCofWPTpSEvP+kKuTwfGAnZJtEkFA=";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/
    cp -R . $out/
    cp $out/bin/setup.conf.txt $out/bin/setup.conf
    runHook postInstall
  '';

  meta = {
    homepage = "https://civicrm.org/";
    changelog = "https://download.civicrm.org/release/${finalAttrs.version}";
    description = "Standalone version of CiviCRM, a CRM software for non-profit organizations";
    license = lib.licenses.agpl3Plus;
    maintainers = [ lib.maintainers.sorooris ];
    mainProgram = "civicrm";
  };
})
