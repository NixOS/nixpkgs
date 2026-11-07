{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "gb-backup";
  version = "0-unstable-2026-08-17";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "leijurv";
    repo = "gb";
    rev = "aa8dcb67edb6b6df47897364d6f5f77f1ec7f485";
    hash = "sha256-0G54vz3+//QcYo2hX+HBUOBd6oSUUbqSzCv1fyoRjuA=";
  };

  vendorHash = "sha256-fjOIp2LUBaAPAPMxU2T+qbIQZgmVa0vNPYzW2hOsBr8=";

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Gamer Backup, a super opinionated cloud backup system";
    homepage = "https://github.com/leijurv/gb";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ babbaj ];
    mainProgram = "gb";
  };
})
