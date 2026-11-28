{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "jumppad";
  version = "0.30.0";

  src = fetchFromGitHub {
    owner = "jumppad-labs";
    repo = "jumppad";
    rev = finalAttrs.version;
    hash = "sha256-FsFpom34wuFt8E7R3w0ZrFJMk+W+69ulxjJ2oeuyroc=";
  };
  vendorHash = "sha256-QHvpDMNRFr0ONjv73pDUTylHhknpPtDsi2vN9n+YlZE=";

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
