{
  lib,
  stdenv,
  fetchurl,
  openldap,
  perl,
}:

stdenv.mkDerivation rec {
  pname = "nss_ldap";
  version = "265";

  src = fetchurl {
    url = "http://www.padl.com/download/nss_ldap-${version}.tar.gz";
    sha256 = "1a16q9p97d2blrj0h6vl1xr7dg7i4s8x8namipr79mshby84vdbp";
  };

  preConfigure = ''
    patchShebangs ./vers_string
    sed -i s,vers_string,./vers_string, Makefile*
    substituteInPlace vers_string --replace "cvslib.pl" "./cvslib.pl"
  '';

  patches = [ ./crashes.patch ];

  postPatch = ''
    patch -p0 < ${./nss_ldap-265-glibc-2.16.patch}
  '';

  preInstall = ''
    installFlagsArray=(INST_UID=$(id -u) INST_GID=$(id -g) LIBC_VERS=2.5 NSS_VERS=2 NSS_LDAP_PATH_CONF=$out/etc/ldap.conf)
    substituteInPlace Makefile \
      --replace '/usr$(libdir)' $TMPDIR \
      --replace 'install-data-local:' 'install-data-local-disabled:'
    mkdir -p $out/etc
  '';

  nativeBuildInputs = [
    perl # shebang of vers_string
  ];

  buildInputs = [
    openldap
  ];

  meta = with lib; {
    description = "LDAP module for the Solaris Nameservice Switch (NSS)";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
