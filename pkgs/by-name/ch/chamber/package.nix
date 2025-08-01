{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "chamber";
  version = "3.1.3";

  src = fetchFromGitHub {
    owner = "segmentio";
    repo = "chamber";
    rev = "v${version}";
    sha256 = "sha256-Hh+u5Rf7YN1Gk2whBMXmtXdXCSeh2CqaQBSzw8KNb5E=";
  };

  env.CGO_ENABLED = 0;

  vendorHash = "sha256-xhfBpLAhAVT42vA2oRm+EQHXA1dWy3UD5m8Ds8/IyAk=";

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=v${version}"
  ];

  meta = with lib; {
    description = "Tool for managing secrets by storing them in AWS SSM Parameter Store";
    homepage = "https://github.com/segmentio/chamber";
    license = licenses.mit;
    maintainers = with maintainers; [ kalekseev ];
    mainProgram = "chamber";
  };
}
