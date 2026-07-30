{
  lib,
  php,
  fetchFromGitHub,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "cv";
  version = "0.3.71";
  __structuredAttrs = true;
  strictDeps = true;
  dontUnpack = false;

  src = fetchFromGitHub {
    owner = "civicrm";
    repo = "cv";
    rev = "v${finalAttrs.version}";
    hash = "sha256-1InNm8ayshrACLUJ4MXb6DTnD9vxRVtwnK9oFAxMMho=";
  };

  vendorHash = "sha256-7+roKbgbSx00CrHDOwp7yxcSTdq9YDNgTLIdjLT05oM=";

  installPhase = ''
    runHook preInstall
    cp -ra $src $out
    runHook postInstall
  '';
  meta = {
    homepage = "https://civicrm.org/";
    changelog = "https://github.com/civicrm/cv/releases/tag/v${finalAttrs.version}";
    description = "CiviCRM CLI Utility";
    license = lib.licenses.agpl3Plus;
    maintainers = [ lib.maintainers.sorooris ];
  };
})
