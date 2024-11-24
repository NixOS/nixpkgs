{ buildGoModule
, fetchFromGitHub
, lib
, testers
, kitex
}:

buildGoModule rec {
  pname = "kitex";
  version = "0.11.3";

  src = fetchFromGitHub {
    owner = "cloudwego";
    repo = "kitex";
    rev = "v${version}";
    hash = "sha256-FjFhbkEMxuBUVfytPk27mrBaAlGXZ9RPWeBy+m0bPV8=";
  };

  vendorHash = "sha256-e98x8lSwO/u8lFbqDmbVNjVG57Y93/P0ls2UUgRvkH0=";

  subPackages = [ "tool/cmd/kitex" ];

  ldflags = [ "-s" "-w" ];

  postInstall = ''
    ln -s $out/bin/kitex $out/bin/protoc-gen-kitex
    ln -s $out/bin/kitex $out/bin/thrift-gen-kitex
  '';

  passthru.tests.version = testers.testVersion {
    package = kitex;
    version = "v${version}";
  };

  meta = with lib;  {
    description = "A high-performance and strong-extensibility Golang RPC framework";
    homepage = "https://github.com/cloudwego/kitex";
    license = licenses.asl20;
    maintainers = with maintainers; [ aaronjheng ];
    mainProgram = "kitex";
  };
}
