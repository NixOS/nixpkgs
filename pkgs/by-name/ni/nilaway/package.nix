{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "nilaway";
  version = "0-unstable-2024-10-10";

  src = fetchFromGitHub {
    owner = "uber-go";
    repo = "nilaway";
    rev = "ba14292918d814eeaea4de62da2ad0daae92f8b0";
    hash = "sha256-HAfuhGxmnMJvkz2vxBZ5kWsgSIw5KKlZp36HCLfCRxo=";
  };

  vendorHash = "sha256-5qaEvQoK5S0svqzFAbJb8wy8yApyRpz4QE8sOhcjdaA=";

  subPackages = [ "cmd/nilaway" ];
  excludedPackages = [ "tools" ];

  ldflags = [
    "-s"
    "-w"
  ];

  preCheck = ''
    # test all paths
    unset subPackages
  '';

  meta = with lib; {
    description = "Static Analysis tool to detect potential Nil panics in Go code";
    homepage = "https://github.com/uber-go/nilaway";
    license = licenses.asl20;
    maintainers = with maintainers; [
      prit342
      jk
    ];
    mainProgram = "nilaway";
  };
}
