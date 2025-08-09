{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "setup-envtest";
  version = "0.19.0";

  src =
    fetchFromGitHub {
      owner = "kubernetes-sigs";
      repo = "controller-runtime";
      rev = "v${version}";
      hash = "sha256-9AqZMiA+OIJD+inmeUc/lq57kV7L85jk1I4ywiSKirg=";
    }
    + "/tools/setup-envtest";

  vendorHash = "sha256-sn3HiKTpQzjrFTOVOGFJwoNpxU+XWgkWD2EOcPilePY=";

  ldflags = [
    "-s"
    "-w"
  ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Tool that manages binaries for envtest, allowing the download of new binaries, listing installed and available ones, and cleaning up versions";
    homepage = "https://github.com/kubernetes-sigs/controller-runtime/tree/v${version}/tools/setup-envtest";
    license = licenses.asl20;
    maintainers = with maintainers; [ arikgrahl ];
    mainProgram = "setup-envtest";
  };
}
