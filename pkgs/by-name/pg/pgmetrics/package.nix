{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "pgmetrics";
  version = "1.19.0";

  src = fetchFromGitHub {
    owner = "rapidloop";
    repo = "pgmetrics";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-PvixAR6jLhwK4nbGWEAnQkjI+JtSwX2izI7/ksi7qs8=";
  };

  vendorHash = "sha256-LphlFl56M8G3kncnj66u1CixgBTLvDBtWqXtUjHDY14=";

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  meta = {
    homepage = "https://pgmetrics.io/";
    description = "Collect and display information and stats from a running PostgreSQL server";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "pgmetrics";
  };
})
