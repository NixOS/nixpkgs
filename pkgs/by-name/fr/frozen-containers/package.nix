{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  nix-update-script,
}:
stdenv.mkDerivation {
  pname = "frozen-containers";
  version = "1.2.0-unstable-2026-09-23";

  src = fetchFromGitHub {
    owner = "serge-sans-paille";
    repo = "frozen";
    rev = "1a6065fc39263b24e024317044d5833d690c474a";
    hash = "sha256-H6kA+su5VHF3uvSG56Sj4LRWaOuvoA2e2XKuQKwly4Y=";
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
