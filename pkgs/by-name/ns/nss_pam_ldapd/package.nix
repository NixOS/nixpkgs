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

stdenv.mkDerivation rec {
  pname = "nss-pam-ldapd";
  version = "0.9.12";

  src = fetchurl {
    url = "https://arthurdejong.org/nss-pam-ldapd/${pname}-${version}.tar.gz";
    sha256 = "sha256-xtZh50aTy/Uxp5BjHKk7c/KR+yPMOUZbCd642iv7DhQ=";
  };

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

  meta = with lib; {
    description = "LDAP identity and authentication for NSS/PAM";
    homepage = "https://arthurdejong.org/nss-pam-ldapd/";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
  };
}
