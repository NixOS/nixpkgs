{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "gobgpd";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "osrg";
    repo = "gobgp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KSP5mdyLbsLij/twNZiuMs8YxVg9gGa7JSmt6Q0btns=";
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
    changelog = "https://github.com/osrg/gobgp/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ higebu ];
  };
})
