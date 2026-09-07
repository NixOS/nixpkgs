{
  lib,
  php,
  fetchFromGitHub,
  civicrm-core,
}:
php.buildComposerProject2 (finalAttrs: {
  pname = "civicrm-standalone";
  version = "1.0.0";
  __structuredAttrs = true;
  strictDeps = true;
  dontUnpack = false;

  src = fetchFromGitHub {
    owner = "civicrm";
    repo = "civicrm-standalone";
    tag = "v${finalAttrs.version}";
    hash = "sha256-P49JDw6MGwhyIsgz8EmgKFuarPS3P4VRV5JnUudiYIg=";
  };

  vendorHash = "sha256-ninW1PL4d/S6m/04cB68Taj7sru73D8X02KISHZvScw=";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/core $out/private $out/public
    cp -R $src/. $out/
    cp -R ${civicrm-core}/. $out/core/
    runHook postInstall
  '';

  meta = {
    homepage = "https://civicrm.org/";
    changelog = "https://download.civicrm.org/release/${finalAttrs.version}";
    description = "Standalone version of CiviCRM, a CRM software for non-profit organizations";
    license = lib.licenses.agpl3Plus;
    maintainers = [ lib.maintainers.sorooris ];
    mainProgram = "civicrm-standalone";
  };
})
