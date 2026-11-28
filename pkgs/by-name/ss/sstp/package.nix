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

stdenv.mkDerivation (finalAttrs: {
  pname = "sstp-client";
  version = "1.0.20";

  src = fetchFromGitLab {
    owner = "sstp-project";
    repo = "sstp-client";
    tag = finalAttrs.version;
    hash = "sha256-6rylWUmZrQbDPPLvOth7rR0v6hu64Ia1crZhO/GcAoY=";
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

  meta = {
    description = "SSTP client for Linux";
    homepage = "https://sstp-client.sourceforge.net/";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ enovamaker ];
    license = lib.licenses.gpl2Plus;
    mainProgram = "sstpc";
  };
})
