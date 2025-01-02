{
  buildGoModule,
  fetchFromGitHub,
  lib,
  testers,
  kitex,
}:

buildGoModule rec {
  pname = "kitex";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "cloudwego";
    repo = "kitex";
    rev = "v${version}";
    hash = "sha256-tCZHDdDwMgZVGeARNfBC3/vQHNN5chKt607R6htx8HI=";
  };

  vendorHash = "sha256-OkCCrdEiq63JTATlsMF3lwZ4JjYIwKOHAz2fqDj64Do=";

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
