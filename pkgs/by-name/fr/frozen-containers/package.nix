{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  nix-update-script,
}:
stdenv.mkDerivation {
  pname = "frozen-containers";
  version = "1.2.0-unstable-2026-04-20";

  src = fetchFromGitHub {
    owner = "serge-sans-paille";
    repo = "frozen";
    rev = "b07a5c8187bc3e6f1461efab89fe07f467e300db";
    hash = "sha256-eZdiLKUcx1MTcW+HyoRi6U/lUbs/qAQhRw0wX3tpUjY=";
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
