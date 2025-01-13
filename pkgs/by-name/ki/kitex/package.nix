{
  buildGoModule,
  fetchFromGitHub,
  lib,
  testers,
  kitex,
}:

buildGoModule rec {
  pname = "kitex";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "cloudwego";
    repo = "kitex";
    rev = "v${version}";
    hash = "sha256-UK+zGMtIZRoITxLrqmPd5mk3FwjjzOLH2Zpke89XgU4=";
  };

  vendorHash = "sha256-dbw4SRYCGlBJCwjcGGVi3u6dkNcXLw9l8EnXPw727cI=";

  subPackages = [ "tool/cmd/kitex" ];

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall = ''
    ln -s $out/bin/kitex $out/bin/protoc-gen-kitex
    ln -s $out/bin/kitex $out/bin/thrift-gen-kitex
  '';

  passthru.tests.version = testers.testVersion {
    package = kitex;
    version = "v${version}";
  };

  meta = {
    description = "A high-performance and strong-extensibility Golang RPC framework";
    homepage = "https://github.com/cloudwego/kitex";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aaronjheng ];
    mainProgram = "kitex";
  };
}
