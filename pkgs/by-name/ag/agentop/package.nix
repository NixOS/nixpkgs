{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "agentop";
  version = "0.1.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mohitmishra786";
    repo = "agentop";
    rev = "v${version}";
    hash = "sha256-lJEWh6SRVekOFsKsuQE88VEoskQAvHm1rPtMq1RQbho=";
  };

  vendorHash = "sha256-AR1IpxAlwRK1uH3iBXMstIZJ/eIV9yeSYtYY2Q29rLg=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/agentop-dev/agentop/cmd.Version=${version}"
  ];

  meta = {
    description = "Terminal dashboard for AI coding assistant sessions — token usage, cost, and cache efficiency";
    homepage = "https://github.com/mohitmishra786/agentop";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "agentop";
  };
}
