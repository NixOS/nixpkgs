{
  lib,
  php,
  fetchFromGitHub,
}:
php.buildComposerProject2 (finalAttrs: {
  pname = "civicrm-core";
  version = "6.16.1";
  __structuredAttrs = true;
  strictDeps = true;
  dontUnpack = false;

  src = fetchFromGitHub {
    owner = "civicrm";
    repo = "civicrm-core";
    tag = finalAttrs.version;
    hash = "sha256-T56hljO656dwXccSlJjGzdHlYfqMUe3Mqzr/xSF/fHE=";
  };

  vendorHash = "sha256-PTDBSTm7C4ygF/YqV1pnHrjzfJ/Kqud1ICq1ObaledQ=";

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
