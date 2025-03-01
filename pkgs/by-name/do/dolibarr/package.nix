{
  lib,
  stdenv,
  fetchFromGitHub,
  nixosTests,
  stateDir ? "/var/lib/dolibarr",
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dolibarr";
  version = "20.0.4";

  src = fetchFromGitHub {
    owner = "Dolibarr";
    repo = "dolibarr";
    tag = finalAttrs.version;
    hash = "sha256-CAVSW/OU8JW8zfu9pK8u2szvTJWPaQzEQcGriHi4s1E=";
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
