{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  nixosTests,
  stateDir ? "/var/lib/dolibarr",
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dolibarr";
  version = "23.0.4";

  src = fetchFromGitHub {
    owner = "Dolibarr";
    repo = "dolibarr";
    tag = finalAttrs.version;
    hash = "sha256-YJKTaLGaILhCFREtAgmX+vzhXIKp0DIj6jn7TtqtFB4=";
  };

  patches = [
    # Remove when updating to Dolibarr 24.0.0 or a 23.x release containing 24b1b99c89c7.
    ./CVE-2026-81728.patch
    # Remove when updating to Dolibarr 24.0.0 or a 23.x release containing fd478850f823.
    (fetchpatch {
      name = "CVE-2026-82633.patch";
      url = "https://github.com/Dolibarr/dolibarr/commit/fd478850f823e27c672300acb4b02baeef79aef1.patch";
      hash = "sha256-OkkQh06r9vnyP/02VIg7ZexT4AQit3rYEgiUC/qnXbg=";
    })
  ];

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
