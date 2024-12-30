{
  lib,
  stdenv,
  fetchFromGitHub,
  pam,
  openldap,
  perl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pam_ldap";
  version = "186";

  src = fetchFromGitHub {
    owner = "PADL";
    repo = "pam_ldap";
    rev = "d1c2e08e4b023708648e2d720add19da6caf77d0";
    hash = "sha256-W0n01HqWZaEoVShXJyND3xGe+snClGm+GZRw7P4fX10=";
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
    changelog = "https://github.com/PADL/pam_ldap/blob/master/ChangeLog";
    longDescription = ''
      The pam_ldap module provides the means for Solaris and Linux servers and
      workstations to authenticate against LDAP directories, and to change their
      passwords in the directory.'';
    license = lib.licenses.gpl2;
    inherit (pam.meta) platforms;
  };
})
