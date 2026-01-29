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
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "saknopper";
    repo = "libnss-mysql";
    rev = "v${finalAttrs.version}";
    sha256 = "1fhsswa3h2nkhjkyjxxqnj07rlx6bmfvd8j521snimx2jba8h0d6";
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
