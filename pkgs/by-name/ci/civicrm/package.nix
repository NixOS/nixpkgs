{
  lib,
  stdenv,
  fetchzip,
}:

stdenv.mkDerivation rec {
  name = "civicrm-standalone";
  version = "6.7.0";
  src = fetchzip {
    url = "https://download.civicrm.org/civicrm-${version}-standalone.tar.gz";
    hash = "sha256-/Kh4iqaC+Vt4DrAhe1Kidz2RBJixOn3uRhV4/SyMDU8=";
  };
  buildPhase = "";
  installPhase = ''
    mkdir -p $out
    cp -ra * $out
  '';

  meta = {
    homepage = "https://civicrm.org/";
    changelog = "https://download.civicrm.org/release/${version}";
    description = "Standalone version of CiviCRM, a CRM software for non-profit organizations.";
    license = lib.licenses.agpl3Plus;
    maintainers = [ lib.maintainers.b12f ];
  };
}
