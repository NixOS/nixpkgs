{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "gb-backup";
  version = "0-unstable-2026-06-05";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "leijurv";
    repo = "gb";
    rev = "d388723a2cbed495bcf1793aa0958a9ba4f3d6b9";
    hash = "sha256-um2wMfHdEL3GkILtM7R/bNW17pknq0M/CCfHPlu6/58=";
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
