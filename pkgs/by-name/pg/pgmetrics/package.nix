{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "pgmetrics";
  version = "1.19.1";

  src = fetchFromGitHub {
    owner = "rapidloop";
    repo = "pgmetrics";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-IwPWhH55GvquVsHswy9p+V6U23UEzYFsPqInqdx6LnI=";
  };

  vendorHash = "sha256-20e4fE30DZMYOSlvhBPJLD5HoCe712NUONnJsvbfQ9g=";

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
