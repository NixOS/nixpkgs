{
  lib,
  nixosTests,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  which,
  libmysqlclient,
}:

stdenv.mkDerivation rec {
  pname = "libnss-mysql";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "saknopper";
    repo = "libnss-mysql";
    rev = "v${version}";
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

  meta = with lib; {
    description = "MySQL module for the Solaris Nameservice Switch (NSS)";
    homepage = "https://github.com/saknopper/libnss-mysql";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ netali ];
  };
}
