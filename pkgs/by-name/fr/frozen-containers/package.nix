{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  nix-update-script,
}:
stdenv.mkDerivation {
  pname = "frozen-containers";
  version = "1.2.0-unstable-2026-11-08";

  src = fetchFromGitHub {
    owner = "serge-sans-paille";
    repo = "frozen";
    rev = "6791f856c7ff69010004e0a456af8ac43935ed80";
    hash = "sha256-oVi3BLbQPl6+nVxX3zVJ3sHWtJ2EL5hr0ze+o2ki1ns=";
  };

  nativeBuildInputs = [ cmake ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Header-only library that provides 0 cost initialization for immutable containers, fixed-size containers, and various algorithms";
    homepage = "https://github.com/serge-sans-paille/frozen";
    maintainers = with lib.maintainers; [
      marcin-serwin
      szanko
    ];
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
  };
}
