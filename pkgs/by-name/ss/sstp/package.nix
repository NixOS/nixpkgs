{
  lib,
  stdenv,
  fetchFromGitLab,
  pkg-config,
  ppp,
  libevent,
  openssl,
  autoreconfHook,
}:

stdenv.mkDerivation {
  pname = "sstp-client";
  version = "unstable-2023-03-25";

  src = fetchFromGitLab {
    owner = "sstp-project";
    repo = "sstp-client";
    rev = "3f7835df9ac5e84729903ca536cf65e4a7b04c6c";
    hash = "sha256-8VF5thSABqf5SXEDCa+0dyDt7kVrQcs6deWLlYWM8dg=";
  };

  postPatch = ''
    sed 's,/usr/sbin/pppd,${ppp}/sbin/pppd,' -i src/sstp-pppd.c
    sed "s,sstp-pppd-plugin.so,$out/lib/pppd/sstp-pppd-plugin.so," -i src/sstp-pppd.c
  '';

  configureFlags = [
    "--with-openssl=${openssl.dev}"
    "--with-runtime-dir=/run/sstpc"
    "--with-pppd-plugin-dir=$(out)/lib/pppd"
  ];

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  buildInputs = [
    libevent
    openssl
    ppp
  ];

  meta = with lib; {
    description = "SSTP client for Linux";
    homepage = "https://sstp-client.sourceforge.net/";
    platforms = platforms.linux;
    maintainers = [ ];
    license = licenses.gpl2Plus;
    mainProgram = "sstpc";
  };
}
