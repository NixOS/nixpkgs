{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "bbctl";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "beeper";
    repo = "bridge-manager";
    rev = "refs/tags/v${version}";
    hash = "sha256-xaBLI5Y7PxHbmlwD72AKNrgnz3D+3WVhb2GJr5cmyfs=";
  };

  vendorHash = "sha256-VnqihTEGfrLxRfuscrWWBbhZ/tr8BhVnCd+FKblW5gI=";

  meta = {
    description = "Tool for running self-hosted bridges with the Beeper Matrix server. ";
    homepage = "https://github.com/beeper/bridge-manager";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.heywoodlh ];
    mainProgram = "bbctl";
    changelog = "https://github.com/beeper/bridge-manager/releases/tag/v{version}";
  };
}
