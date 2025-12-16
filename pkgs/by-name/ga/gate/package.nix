{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

let
  pname = "gate";
  version = "0.61.0";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "minekube";
    repo = "gate";
    tag = "v${version}";
    hash = "sha256-HCxsydmCjhbL2hiZ4EEjsODXKWoAv2Azi/HvUU6aOIg=";
  };

  vendorHash = "sha256-f7SkECS80Lwkd0xSzHq+x05ZBjBYKXsA4rPidyIAYak=";

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
}
