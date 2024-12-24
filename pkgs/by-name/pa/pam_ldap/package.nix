{
  stdenv,
  fetchurl,
  pam,
  openldap,
  perl,
}:

stdenv.mkDerivation rec {
  pname = "pam_ldap";
  version = "186";

  src = fetchurl {
    url = "https://www.padl.com/download/pam_ldap-${version}.tar.gz";
    sha256 = "0lv4f7hc02jrd2l3gqxd247qq62z11sp3fafn8lgb8ymb7aj5zn8";
  };

  postPatch = ''
    patchShebangs ./vers_string
    substituteInPlace vers_string --replace "cvslib.pl" "./cvslib.pl"
  '';

  preInstall = "
    substituteInPlace Makefile --replace '-o root -g root' ''
  ";

  nativeBuildInputs = [ perl ];
  buildInputs = [
    pam
    openldap
  ];

  meta = {
    homepage = "https://www.padl.com/OSS/pam_ldap.html";
    description = "LDAP backend for PAM";
    longDescription = ''
      The pam_ldap module provides the means for Solaris and Linux servers and
      workstations to authenticate against LDAP directories, and to change their
      passwords in the directory.'';
    license = "LGPL";
    inherit (pam.meta) platforms;
  };
}
