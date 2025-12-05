{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "gobgpd";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "osrg";
    repo = "gobgp";
    tag = "v${version}";
    hash = "sha256-hXpNNDGiiJ0m8TjZe4ZOFhwma7KG7bm5iud1F0lcRzg=";
  };

  vendorHash = "sha256-y8nhrKQnTXfnDDyr/xZd5b9ccXaM85rd8RKHtoDBuwI=";

  postConfigure = ''
    export CGO_ENABLED=0
  '';

  ldflags = [
    "-s"
    "-w"
    "-extldflags '-static'"
  ];

  subPackages = [
    "cmd/gobgpd"
  ];

  passthru.tests = { inherit (nixosTests) gobgpd; };

  meta = {
    description = "BGP implemented in Go";
    mainProgram = "gobgpd";
    homepage = "https://osrg.github.io/gobgp/";
    changelog = "https://github.com/osrg/gobgp/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ higebu ];
  };
}
