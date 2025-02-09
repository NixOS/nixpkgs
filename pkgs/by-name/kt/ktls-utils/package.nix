{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, gnutls
, keyutils
, glib
, libnl
, systemd
, withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd
}:

stdenv.mkDerivation rec {
  pname = "ktls-utils";
  version = "0.10";

  src = fetchFromGitHub {
    owner = "oracle";
    repo = "ktls-utils";
    rev = "ktls-utils-${version}";
    hash = "sha256-1HceFajSSq1D3IMeGQF+i/iW1lL2opLLWFfsRHW9atg=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    gnutls
    keyutils
    glib
    libnl
  ];

  outputs = [ "out" "man" ];

  configureFlags = lib.optional withSystemd [ "--with-systemd" ];

  makeFlags = lib.optional withSystemd [ "unitdir=$(out)/lib/systemd/system" ];

  doCheck = true;

  meta = with lib; {
    description = "TLS handshake utilities for in-kernel TLS consumers";
    homepage = "https://github.com/oracle/ktls-utils";
    changelog = "https://github.com/oracle/ktls-utils/blob/${src.rev}/NEWS";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ ];
    mainProgram = "ktls-utils";
    platforms = platforms.linux;
  };
}
