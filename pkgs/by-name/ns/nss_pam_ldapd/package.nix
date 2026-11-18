{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  makeWrapper,
  autoreconfHook,
  openldap,
  python3,
  pam,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nss-pam-ldapd";
  version = "0.9.13";

  src = fetchurl {
    url = "https://arthurdejong.org/nss-pam-ldapd/nss-pam-ldapd-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-4BeE4Xy1M7tmvQYB4gXnhSY0RcPC33pvkCMqtBMccW0=";
  };

  patches = [
    # Fix C23 compatibility: rename 'bool' variable which is now a keyword
    ./fix-bool-c23-keyword.patch
  ];

  nativeBuildInputs = [
    pkg-config
    makeWrapper
    autoreconfHook
  ];
  buildInputs = [
    openldap
    pam
    python3
  ];

  preConfigure = ''
    substituteInPlace Makefile.in --replace "install-data-local: " "# install-data-local: "
  '';

  configureFlags = [
    "--with-bindpw-file=/run/nslcd/bindpw"
    "--with-nslcd-socket=/run/nslcd/socket"
    "--with-nslcd-pidfile=/run/nslcd/nslcd.pid"
    "--with-pam-seclib-dir=$(out)/lib/security"
    "--enable-kerberos=no"
  ];

  postInstall = ''
    wrapProgram $out/sbin/nslcd --prefix LD_LIBRARY_PATH ":" $out/lib
  '';

  meta = {
    description = "LDAP identity and authentication for NSS/PAM";
    homepage = "https://arthurdejong.org/nss-pam-ldapd/";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})
