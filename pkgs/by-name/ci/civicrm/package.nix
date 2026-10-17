{
  lib,
  php,
  fetchFromGitHub,
}:
php.buildComposerProject2 (finalAttrs: {
  pname = "civicrm-core";
  version = "6.19.0";
  __structuredAttrs = true;
  strictDeps = true;
  dontUnpack = false;

  src = fetchFromGitHub {
    owner = "civicrm";
    repo = "civicrm-core";
    tag = finalAttrs.version;
    hash = "sha256-zLcwRlnqQ07gAlj+np0iHbDhy/VpXd2mqPB+JhE5pfo=";
  };

  vendorHash = "sha256-3XIyYmfTjvrwPWXn4EbLu4J0sngy2yEfornLH2blp+I=";

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
