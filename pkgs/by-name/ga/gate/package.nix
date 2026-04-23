{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "gate";
  version = "0.62.4";

  src = fetchFromGitHub {
    owner = "minekube";
    repo = "gate";
    tag = "v${finalAttrs.version}";
    hash = "sha256-25XroGctY1Oe/OPD/WRQMKKmNz4DtlFBjzOghzTq4tw=";
  };

  vendorHash = "sha256-aPlAZHMJ8LYBuaaLw+ZT0V8rB+ktrf6rjuaztzZFYDQ=";

  ldflags = [
    "-s"
    "-w"
  ];

  # this test requires network access, therefore it should not be run
  preCheck = ''
    rm ./pkg/edition/bedrock/geyser/managed/download_test.go
  '';

  excludedPackages = [ ".web" ];

  meta = {
    description = "High-Performance, Low-Memory, Lightweight, Extensible Minecraft Reverse Proxy";
    longDescription = ''
      Gate is an extensible, high performant & paralleled Minecraft proxy server
      with scalability, flexibility & excellent server version support - written in Go
      and ready for the cloud!
    '';
    homepage = "https://github.com/minekube/gate";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ XBagon ];
    mainProgram = "gate";
  };
})
