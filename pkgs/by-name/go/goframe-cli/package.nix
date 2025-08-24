{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gf";
  version = "2.9.0";

  src = fetchFromGitHub {
    owner = "gogf";
    repo = "gf";
    tag = "v${version}";
    hash = "sha256-Llb3LC5ok4MBJgk5yEqIgnIi2+l+JRrBiscM8LbskZM=";
  };

  vendorHash = "sha256-eU+SXEgNz/zMPGNDR71DwZwp6vGyyXAgWiPob4uf3GE=";

  modRoot = "cmd/gf";
  subPackages = [ "." ];

  doCheck = true;

  env = {
    GOWORK = "off";
  };

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "gf is a powerful CLI tool for building GoFrame application with convenience";
    homepage = "https://goframe.org";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cococolanosugar ];
    mainProgram = "gf";
  };
}
