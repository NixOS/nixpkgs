{
  lib,
  php,
  fetchFromGitHub,
}:
php.buildComposerProject2 (finalAttrs: {
  pname = "civicrm-core";
  version = "6.17.3";
  __structuredAttrs = true;
  strictDeps = true;
  dontUnpack = false;

  src = fetchFromGitHub {
    owner = "civicrm";
    repo = "civicrm-core";
    tag = finalAttrs.version;
    hash = "sha256-9BZ/xjJGvZO0V8QJV8yuZj5uRmWbS68/KF1q7Xrz5/8=";
  };

  vendorHash = "sha256-40i9jTbY7NgfHvjL1/COyRpteRfveBGkHMnv00gdem8=";

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
