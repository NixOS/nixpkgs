{
  buildGoModule,
  fetchFromGitHub,
  lib,
  testers,
  kitex,
}:

buildGoModule rec {
  pname = "kitex";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "cloudwego";
    repo = "kitex";
    rev = "v${version}";
    hash = "sha256-1dgQgc9XljawyH+MIDPNqcwHMH0yW2BMY8TZnc+P13I=";
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
