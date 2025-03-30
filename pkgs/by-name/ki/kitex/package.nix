{
  buildGoModule,
  fetchFromGitHub,
  lib,
  testers,
  kitex,
}:

buildGoModule rec {
  pname = "kitex";
  version = "0.12.3";

  src = fetchFromGitHub {
    owner = "cloudwego";
    repo = "kitex";
    rev = "v${version}";
    hash = "sha256-YJq/aE8M/yRed2ZH7zf6i5wRl9KKXxAncD0lNAmJXUM=";
  };

  vendorHash = "sha256-yIPcH1arDSYfCqSbBTvbnp4UORx11bbuT//fy89bzF0=";

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
