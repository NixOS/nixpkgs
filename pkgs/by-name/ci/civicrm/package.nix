{
  lib,
  php,
  fetchFromGitHub,
  cacert,
}:
php.buildComposerProject2 (finalAttrs: {
  pname = "civicrm-core";
  version = "6.20.1";
  __structuredAttrs = true;
  strictDeps = true;
  dontUnpack = false;

  src = fetchFromGitHub {
    owner = "civicrm";
    repo = "civicrm-core";
    tag = finalAttrs.version;
    hash = "sha256-AaKnOxOxbLIkh/EdQTHRqHAI9AHKpN1tO+ZmBYASF1g=";
  };

  vendorHash = "sha256-/EQPRGwGOscELXTaelfgo7WjdUuiQ+k4VNqwBb/orzQ=";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/
    cp -R . $out/
    cp $out/bin/setup.conf.txt $out/bin/setup.conf
    runHook postInstall
  '';

  # CA_Config_Curl reads cacert.pem only on Windows, but the output still ships it.
  postInstall = ''
    for f in \
      $out/vendor/totten/ca-config/src/CA/Config/cacert.pem \
      $out/share/php/civicrm-core/vendor/totten/ca-config/src/CA/Config/cacert.pem; do
      rm $f
      ln -s ${cacert}/etc/ssl/certs/ca-bundle.crt $f
    done
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
