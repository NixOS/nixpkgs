{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "gb-backup";
  version = "0-unstable-2026-11-10";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "leijurv";
    repo = "gb";
    rev = "2fda32c0af235cfa32af537c52dd31987eba5956";
    hash = "sha256-sGHgfhVTGwB6369OWkcqgrVmHTB4FS15fC3Fz0L0TEo=";
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
