{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "jumppad";
  version = "0.17.1";

  src = fetchFromGitHub {
    owner = "jumppad-labs";
    repo = "jumppad";
    rev = version;
    hash = "sha256-SoiF5y0Vc2T8qT75cII3HqNSEZhWAzKEk3xw4BGICpo=";
  };
  vendorHash = "sha256-mJKawveIoDu2v+GxIoljmFbCwle9d1SQiHzsoerP66I=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-X main.version=${version}"
  ];

  # Tests require a large variety of tools and resources to run including
  # Kubernetes, Docker, and GCC.
  doCheck = false;

  meta = with lib; {
    description = "Tool for building modern cloud native development environments";
    homepage = "https://jumppad.dev";
    license = licenses.mpl20;
    maintainers = with maintainers; [ cpcloud ];
    mainProgram = "jumppad";
  };
}
