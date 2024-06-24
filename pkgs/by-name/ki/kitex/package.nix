{ buildGoModule
, fetchFromGitHub
, lib
, testers
, kitex
}:

buildGoModule rec {
  pname = "kitex";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "cloudwego";
    repo = "kitex";
    rev = "v${version}";
    hash = "sha256-eiwOivulPBYEK7Pmztmb2dgUytPT0hZW5BiCpovUZWw=";
  };

  vendorHash = "sha256-4tOi1BENGNdqo3xG7PnKbIUb/QsUFhm0wDcRYrMGC0M=";

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
