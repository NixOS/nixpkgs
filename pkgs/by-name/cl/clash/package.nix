{
  lib,
  fetchFromGitHub,
  buildGoModule,
  testers,
  clash,
}:

buildGoModule rec {
  pname = "clash";
  version = "1.18.0";

  # Canonical upstream has been removed.
  src = fetchFromGitHub {
    owner = "aaronjheng";
    repo = "clash";
    rev = "v${version}";
    hash = "sha256-LqjSPlPkR5sB4Z1pmpdE9r66NN7pwgE9GK4r1zSFlxs=";
  };

  vendorHash = "sha256-EWAbEFYr15RiJk9IXF6KaaX4GaSCa6E4+8rKL4/XG8Y=";

  subPackages = [ "." ];

  CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/Dreamacro/clash/constant.Version=${version}"
  ];

  passthru.tests.version = testers.testVersion {
    package = clash;
    command = "clash -v";
  };

  meta = {
    description = "Rule-based tunnel in Go";
    homepage = "https://github.com/Dreamacro/clash";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ aaronjheng ];
    mainProgram = "clash";
  };
}
