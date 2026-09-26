{
  buildGoModule,
  fetchFromGitHub,
  lib,
  testers,
  kitex,
}:

buildGoModule (finalAttrs: {
  pname = "kitex";
  version = "0.16.2";

  src = fetchFromGitHub {
    owner = "cloudwego";
    repo = "kitex";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RlKdOpe1VhSLPBghBDcC+pi4sodwrNg4vNMGe9A9uYM=";
  };

  vendorHash = "sha256-aKZvMS6dm8EqZgelZ4eCgM7dAob99rEJSURX/Lz2UyU=";

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
    version = "v${finalAttrs.version}";
  };

  meta = {
    description = "High-performance and strong-extensibility Golang RPC framework";
    homepage = "https://github.com/cloudwego/kitex";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "kitex";
  };
})
