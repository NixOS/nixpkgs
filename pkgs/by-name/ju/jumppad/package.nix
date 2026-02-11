{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "jumppad";
  version = "0.24.0";

  src = fetchFromGitHub {
    owner = "jumppad-labs";
    repo = "jumppad";
    rev = finalAttrs.version;
    hash = "sha256-OH06qQ+gkPv9McHr+YiMRiqTvdvhW9UqcEJK2NZxGQo=";
  };
  vendorHash = "sha256-m2aMRQ/K8etAKgGEcMbOrx2cYxp3ncdLe70Q3zYdj4I=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-X main.version=${finalAttrs.version}"
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
})
