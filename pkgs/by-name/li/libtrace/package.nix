{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  bison,
  flex,
  zlib,
  bzip2,
  xz,
  libpcap,
  wandio,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libtrace";
  version = "4.0.28-1";

  src = fetchFromGitHub {
    owner = "LibtraceTeam";
    repo = "libtrace";
    tag = finalAttrs.version;
    hash = "sha256-impZrZOOORsQaUz04pkCXGxJkXGaCBcJD390hm74peA=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    bison
    flex
  ];
  buildInputs = [
    zlib
    bzip2
    xz
    libpcap
    wandio
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version-regex=^([0-9.-]+)$" ]; };

  meta = {
    description = "C Library for working with network packet traces";
    homepage = "https://github.com/LibtraceTeam/libtrace";
    changelog = "https://github.com/LibtraceTeam/libtrace/releases/tag/${finalAttrs.version}";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ felbinger ];
    platforms = lib.platforms.unix;
  };
})
