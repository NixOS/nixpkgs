{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "spruce";
  version = "1.31.1";

  src = fetchFromGitHub {
    owner = "geofffranks";
    repo = "spruce";
    rev = "v${version}";
    hash = "sha256-wLxPHaCU0fciSIdK26dV4XOnJsp5EKKEXzgspWC1GvA=";
  };

  vendorHash = null;

  meta = {
    description = "BOSH template merge tool";
    mainProgram = "spruce";
    homepage = "https://github.com/geofffranks/spruce";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ risson ];
  };
}
