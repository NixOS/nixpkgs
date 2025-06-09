{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "pgmetrics";
  version = "1.17.1";

  src = fetchFromGitHub {
    owner = "rapidloop";
    repo = "pgmetrics";
    rev = "v${version}";
    sha256 = "sha256-SaJc09RRm8MR8OiBIznCRHLhpflQ4Gi8tlXQvYd/j9A=";
  };

  vendorHash = "sha256-/QAdHC2Ge2Bp2zcn9cpgCPpT8TADqeJC4GlJWsGPe8Q=";

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  meta = with lib; {
    homepage = "https://pgmetrics.io/";
    description = "Collect and display information and stats from a running PostgreSQL server";
    license = licenses.asl20;
    maintainers = [ ];
    mainProgram = "pgmetrics";
  };
}
