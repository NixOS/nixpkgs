{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "gate";
  version = "0.62.3";

  src = fetchFromGitHub {
    owner = "minekube";
    repo = "gate";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tOyXVqmexAWpC2s86aUUjmDp6V+qvP3ve8FrqdtexvU=";
  };

  vendorHash = "sha256-AZa9u1f8MgnqW0QX6X+naRqukGTxI7WMNY4ZgJHoKyw=";

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
