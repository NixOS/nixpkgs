{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "bufisk";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "bufbuild";
    repo = "bufisk";
    rev = "v${version}";
    hash = "sha256-pVnqvQn7jwpx6T3sS4eA29JeJdh0GrPVm0J8n2UjJTw=";
  };

  vendorHash = "sha256-iv5zIn9C56AQB87T+n5fJzm/fhBFBUObFwrlJ72A/J4=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    homepage = "https://github.com/bufbuild/bufisk";
    description = "User-friendly launcher for Buf";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aaronjheng ];
    mainProgram = "bufisk";
  };
}
