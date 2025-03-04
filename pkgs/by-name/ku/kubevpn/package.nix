{
  lib,
  buildGoModule,
  fetchFromGitHub,
  go,
}:

buildGoModule rec {
  pname = "kubevpn";
  version = "2.3.12";

  src = fetchFromGitHub {
    owner = "KubeNetworks";
    repo = "kubevpn";
    rev = "v${version}";
    hash = "sha256-KRItrvMyTAXJWLCPzJ4Ifm9VS8aMWqyFFLC5dA7oboo=";
  };

  vendorHash = null;

  tags = [
    "noassets" # required to build synthing gui without generating assets
  ];

  ldflags = [
    "-X github.com/wencaiwulue/kubevpn/v2/pkg/config.Version=v${version}"
    "-X github.com/wencaiwulue/kubevpn/v2/cmd/kubevpn/cmds.OsArch=${go.GOOS}/${go.GOARCH}"
  ];

  # Resolve configuration tests, which access $HOME
  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  # Disable network tests
  checkFlags = [
    "-skip=^Test(Route|Functions|ByDumpClusterInfo|ByCreateSvc|Elegant)$"
  ];

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/kubevpn help
    $out/bin/kubevpn version | grep -e "Version: v${version}"
    runHook postInstallCheck
  '';

  meta = with lib; {
    changelog = "https://github.com/KubeNetworks/kubevpn/releases/tag/${src.rev}";
    description = "Create a VPN and connect to Kubernetes cluster network, access resources, and more";
    mainProgram = "kubevpn";
    homepage = "https://github.com/KubeNetworks/kubevpn";
    license = licenses.mit;
    maintainers = with maintainers; [ mig4ng ];
  };
}
