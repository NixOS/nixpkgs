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

stdenv.mkDerivation (finalAttrs: {
  pname = "ktls-utils";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "oracle";
    repo = "ktls-utils";
    rev = "ktls-utils-${finalAttrs.version}";
    hash = "sha256-xBh9iSmTf8YCfahWnJvDx/nvz91NFZ3AiJ2JYs+pMfY=";
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

  meta = {
    description = "TLS handshake utilities for in-kernel TLS consumers";
    homepage = "https://github.com/oracle/ktls-utils";
    changelog = "https://github.com/oracle/ktls-utils/blob/${finalAttrs.src.rev}/NEWS";
    license = lib.licenses.gpl2Only;
    maintainers = [ ];
    mainProgram = "tlshd";
    platforms = lib.platforms.linux;
  };
})
