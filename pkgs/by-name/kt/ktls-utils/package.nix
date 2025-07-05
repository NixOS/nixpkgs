{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  gnutls,
  keyutils,
  glib,
  libnl,
  systemd,
  withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "ktls-utils";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "oracle";
    repo = "ktls-utils";
    rev = "ktls-utils-${version}";
    hash = "sha256-UQMM4P2YZbdB8H+kTLPBKLces0HJHAO3f21VvI1yNmk=";
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

  outputs = [
    "out"
    "man"
  ];

  configureFlags = lib.optional withSystemd [ "--with-systemd" ];

  makeFlags = lib.optional withSystemd [ "unitdir=$(out)/lib/systemd/system" ];

  doCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "TLS handshake utilities for in-kernel TLS consumers";
    homepage = "https://github.com/oracle/ktls-utils";
    changelog = "https://github.com/oracle/ktls-utils/blob/${src.rev}/NEWS";
    license = licenses.gpl2Only;
    maintainers = [ ];
    mainProgram = "ktls-utils";
    platforms = platforms.linux;
  };
}
