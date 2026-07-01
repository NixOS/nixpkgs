{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cv";
  version = "0.3.71";

  src = fetchFromGitHub {
    owner = "civicrm";
    repo = "cv";
    rev = "v${finalAttrs.version}";
    hash = "sha256-1InNm8ayshrACLUJ4MXb6DTnD9vxRVtwnK9oFAxMMho=";
  };

  __structuredAttrs = true;
  strictDeps = true;
  dontUnpack = true;
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
