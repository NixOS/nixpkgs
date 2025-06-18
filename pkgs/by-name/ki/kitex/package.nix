{
  buildGoModule,
  fetchFromGitHub,
  lib,
  testers,
  kitex,
}:

buildGoModule (finalAttrs: {
  pname = "kitex";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "cloudwego";
    repo = "kitex";
    tag = "v${finalAttrs.version}";
    hash = "sha256-I5jXSrhpEkTuBfKJCHlGk5nKeW4pVujEscB0Lb3MdbM=";
  };

  vendorHash = "sha256-nTwS5QeTmWfMVEcvsgyx4XbGG5Nk0dzAjXBtvJdpR9c=";

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
    maintainers = with lib.maintainers; [ aaronjheng ];
    mainProgram = "kitex";
  };
})
