{
  stdenv,
  lib,
  fetchFromGitHub,
  nixosTests,
  stateDir ? "/var/lib/dolibarr",
}:

stdenv.mkDerivation rec {
  pname = "dolibarr";
  version = "20.0.2";

  src = fetchFromGitHub {
    owner = "Dolibarr";
    repo = "dolibarr";
    tag = version;
    hash = "sha256-5OEZpBxTYXhO27ea/GBmJI9uDLRDgMNc9ehQ7mvvSrY=";
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

  passthru.tests = { inherit (nixosTests) dolibarr; };

  meta = {
    description = "Enterprise resource planning (ERP) and customer relationship manager (CRM) server";
    changelog = "https://github.com/Dolibarr/dolibarr/releases/tag/${src.tag}";
    homepage = "https://dolibarr.org/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
