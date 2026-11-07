{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  nix-update-script,
}:
stdenv.mkDerivation {
  pname = "frozen-containers";
  version = "1.2.0-unstable-2026-10-09";

  src = fetchFromGitHub {
    owner = "serge-sans-paille";
    repo = "frozen";
    rev = "d53e0a11578d56dc331dc267c2084d52bcdee1d9";
    hash = "sha256-j/K8KbQKkucM0JYmXSTXRk/PcdlADpDeLzkWfyHq1q0=";
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
