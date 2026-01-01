{
  lib,
  stdenv,
  fetchFromGitHub,
  nixosTests,
  stateDir ? "/var/lib/dolibarr",
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dolibarr";
<<<<<<< HEAD
  version = "22.0.4";
=======
  version = "22.0.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "Dolibarr";
    repo = "dolibarr";
    tag = finalAttrs.version;
<<<<<<< HEAD
    hash = "sha256-jk1sjVZJvFeJtQjxgNRx+WLSDsevMvxUIFCO4JMPEHM=";
=======
    hash = "sha256-3dcui1A8EzcFogQfUkf9+8A1C1CcFxHPFjOybDLKaCY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  dontBuild = true;

  postPatch = ''
    find . -type f -name "*.php" -print0 | xargs -0 sed -i 's|/etc/dolibarr|${stateDir}|g'

    substituteInPlace htdocs/filefunc.inc.php \
      --replace-fail '//$conffile = ' '$conffile = ' \
      --replace-fail '//$conffiletoshow = ' '$conffiletoshow = '

    substituteInPlace htdocs/install/inc.php \
      --replace-fail '//$conffile = ' '$conffile = ' \
      --replace-fail '//$conffiletoshow = ' '$conffiletoshow = '
  '';

  installPhase = ''
    mkdir -p "$out"
    cp -r * $out
  '';

  passthru.tests = lib.optionalAttrs stdenv.hostPlatform.isLinux {
    inherit (nixosTests) dolibarr;
  };

  meta = {
    description = "Enterprise resource planning (ERP) and customer relationship manager (CRM) server";
    changelog = "https://github.com/Dolibarr/dolibarr/releases/tag/${finalAttrs.version}";
    homepage = "https://dolibarr.org/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
