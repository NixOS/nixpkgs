{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  json_c,
  libnet,
  libpcap,
  openssl,
}:

stdenv.mkDerivation {
  pname = "ssldump";
  version = "1.8-unstable-2024-10-16";

  src = fetchFromGitHub {
    owner = "adulau";
    repo = "ssldump";
    rev = "a7534300bb09184fec991b3b4f19a40538b8adea";
    hash = "sha256-6jmIPkyT5QCqQw07unc6nKTlxpajiLO05IFshWtCh7w=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    json_c
    libnet
    libpcap
    openssl
  ];

  meta = {
    description = "SSLv3/TLS network protocol analyzer";
    homepage = "https://ssldump.sourceforge.net";
    license = with lib.licenses; [
      bsdOriginal
      bsdOriginalShortened
    ];
    maintainers = with lib.maintainers; [ aycanirican ];
    platforms = lib.platforms.unix;
    mainProgram = "ssldump";
  };
}
