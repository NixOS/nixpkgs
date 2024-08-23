{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "bbctl";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "beeper";
    repo = "bridge-manager";
    rev = "refs/tags/v${version}";
    hash = "sha256-MAve7ZNS20XBJ7Qp3mehznli04+MS7RiVWW1txdf19U=";
  };

  vendorHash = "sha256-uz4pao8Y/Sb3fffi9d0lbWQEUMohbthA6t6k6PfQz2M=";

  meta = {
    description = "Tool for running self-hosted bridges with the Beeper Matrix server. ";
    homepage = "https://github.com/beeper/bridge-manager";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.heywoodlh ];
    mainProgram = "bbctl";
    changelog = "https://github.com/beeper/bridge-manager/releases/tag/v{version}";
  };
}
