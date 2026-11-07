{
  lib,
  fetchurl,
  openldap,
  buildPerlPackage,
}:

buildPerlPackage rec {
  pname = "Mozilla-Ldap";
  version = "1.5.3";

  env = {
    USE_OPENLDAP = 1;
    LDAPSDKDIR = openldap.dev;
    LDAPSDKLIBDIR = "${openldap.out}/lib";
  };

  src = fetchurl {
    url = "https://ftp.mozilla.org/pub/directory/perldap/releases/${version}/src/perl-mozldap-${version}.tar.gz";
    hash = "sha256-nXB746Em3WABIF73LlnkuJLc2js6Hn0GH29/wNuiCmg=";
  };
  meta = {
    description = "Mozilla's ldap client library";
    homepage = "https://metacpan.org/release/perldap";
    license = with lib.licenses; [
      mpl20
      lgpl21Plus
      gpl2Plus
    ];
  };
}
