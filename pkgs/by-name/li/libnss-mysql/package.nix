{
  lib,
  nixosTests,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  which,
  libmysqlclient,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libnss-mysql";
  version = "1.7.2";

  src = fetchFromGitHub {
    owner = "saknopper";
    repo = "libnss-mysql";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-/oeUe94NfOzKrHhiIEW0cMXP5pAqPHulRO82JwPrv5I=";
  };

  nativeBuildInputs = [
    autoreconfHook
    which
  ];
  buildInputs = [ libmysqlclient ];

  configureFlags = [ "--sysconfdir=/etc" ];
  installFlags = [ "sysconfdir=$(out)/etc" ];
  postInstall = ''
    rm -r $out/etc
  '';

  passthru.tests = {
    inherit (nixosTests) auth-mysql;
  };

  meta = {
    description = "MySQL module for the Solaris Nameservice Switch (NSS)";
    homepage = "https://github.com/saknopper/libnss-mysql";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ netali ];
  };
})
