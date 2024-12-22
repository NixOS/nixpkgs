{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "bbctl";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "beeper";
    repo = "bridge-manager";
    rev = "refs/tags/v${version}";
    hash = "sha256-bNnansZNshWp70LQQsa6+bS+LJxpCzdTkL2pX+ksrP0=";
  };

  vendorHash = "sha256-yTNUxwnulQ+WbHdQbeNDghH4RPXurQMIgKDyXfrMxG8=";

  meta = {
    description = "Tool for running self-hosted bridges with the Beeper Matrix server.";
    homepage = "https://github.com/beeper/bridge-manager";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.heywoodlh ];
    mainProgram = "bbctl";
    changelog = "https://github.com/beeper/bridge-manager/releases/tag/v${version}";
  };
}
