{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "setup-envtest";
  version = "0.22.3";

  src =
    fetchFromGitHub {
      owner = "kubernetes-sigs";
      repo = "controller-runtime";
      rev = "v${version}";
      hash = "sha256-Al1MILraagj5b2AatweT3uGv/xpFYgLN/vEXCE/w630=";
    }
    + "/tools/setup-envtest";

  vendorHash = "sha256-1WxRIvzVUg+6XUWTAs6SVR12vGihUFkuwH1jH10Oa50=";

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
