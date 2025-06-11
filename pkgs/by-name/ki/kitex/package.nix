{
  buildGoModule,
  fetchFromGitHub,
  lib,
  testers,
  kitex,
}:

buildGoModule (finalAttrs: {
  pname = "kitex";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "cloudwego";
    repo = "kitex";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ivuAqHOerGkaEX/zfzViY1xhNrymMOBv8RPGAPNYp/4=";
  };

  vendorHash = "sha256-31OgNcAL2NJq5b96UmQnVecdusY4AtUP/O2MVCmPk+8=";

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
