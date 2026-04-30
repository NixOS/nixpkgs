{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "headlamp-server";
  version = "0.41.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = "headlamp";
    tag = "v${version}";
    hash = "sha256-ZXyE4oPkwimnU2ArOiTCnLxzaI5z/7T/SHS9aqP2DGM=";
  };

  modRoot = "backend";

  vendorHash = "sha256-JjfB93C97yTbUTUbs7wEB/iFtuRzHzFXGyRHDAec7X8=";

  # Don't embed frontend - Electron serves it directly. This also prevents
  # the server from auto-opening a browser window.

  ldflags = [
    "-s"
    "-w"
    "-X github.com/kubernetes-sigs/headlamp/backend/pkg/kubeconfig.Version=${version}"
    "-X github.com/kubernetes-sigs/headlamp/backend/pkg/kubeconfig.AppName=Headlamp"
  ];

  subPackages = [ "cmd" ];

  postInstall = ''
    mv $out/bin/cmd $out/bin/headlamp-server
  '';

  meta = {
    description = "An easy-to-use and extensible Kubernetes web UI";
    homepage = "https://headlamp.dev";
    changelog = "https://github.com/kubernetes-sigs/headlamp/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dylanmtaylor ];
    mainProgram = "headlamp-server";
  };
}
