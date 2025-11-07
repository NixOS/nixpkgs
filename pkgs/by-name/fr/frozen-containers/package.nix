{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  nix-update-script,
}:
stdenv.mkDerivation {
  pname = "frozen-containers";
  version = "1.2.0-unstable-2025-07-29";

  src = fetchFromGitHub {
    owner = "serge-sans-paille";
    repo = "frozen";
    rev = "61dce5ae18ca59931e27675c468e64118aba8744";
    hash = "sha256-zIczBSRDWjX9hcmYWYkbWY3NAAQwQtKhMTeHlYp4BKk=";
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
