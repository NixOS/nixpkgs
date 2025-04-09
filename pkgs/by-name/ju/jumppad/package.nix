{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "jumppad";
  version = "0.18.1";

  src = fetchFromGitHub {
    owner = "jumppad-labs";
    repo = "jumppad";
    rev = version;
    hash = "sha256-2QF37dDQP+rSaLeNE9a41sA8iWnlUQaeXS00FoLdnfY=";
  };
  vendorHash = "sha256-BuXbizA/OJiP11kSIO476tWPYPzGTKmzPHeyIqs8pWc=";

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
