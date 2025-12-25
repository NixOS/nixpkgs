{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "jumppad";
  version = "0.23.3";

  src = fetchFromGitHub {
    owner = "jumppad-labs";
    repo = "jumppad";
    rev = version;
    hash = "sha256-HNNvHAbCC1Et7bwLiDTwNU1oeLYlLfOMaxdRRkHu9gA=";
  };
  vendorHash = "sha256-m2aMRQ/K8etAKgGEcMbOrx2cYxp3ncdLe70Q3zYdj4I=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-X main.version=${version}"
  ];

  # Tests require a large variety of tools and resources to run including
  # Kubernetes, Docker, and GCC.
  doCheck = false;

  meta = {
    description = "Tool for building modern cloud native development environments";
    homepage = "https://jumppad.dev";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ cpcloud ];
    mainProgram = "jumppad";
  };
}
