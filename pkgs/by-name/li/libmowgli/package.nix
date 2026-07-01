{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libmowgli";
  version = "2.1.3-unstable-2024-04-01";

  src = fetchFromGitHub {
    owner = "atheme";
    repo = "libmowgli-2";
    rev = "878f7e931b55d36e2e1b27807f7a620cbb0577d8";
    hash = "sha256-Ik0GDsC0vEFNW/s10u+kNubqVh95ZqXb2I5W9iyU1z4=";
  };

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Development framework for C providing high performance and highly flexible algorithms";
    homepage = "https://github.com/atheme/libmowgli-2";
    license = lib.licenses.isc;
    platforms = lib.platforms.unix;
  };
})
