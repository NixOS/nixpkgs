{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "multus-cni";
  version = "4.0.2";

  src = fetchFromGitHub {
    owner = "k8snetworkplumbingwg";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Q6ACXOv1E3Ouki4ksdlUZFbWcDgo9xbCiTfEiVG5l18=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X=gopkg.in/k8snetworkplumbingwg/multus-cni.v3/pkg/multus.version=${version}"
  ];

  preInstall = ''
    mv $GOPATH/bin/cmd $GOPATH/bin/multus
  '';

  vendorHash = null;

  # Some of the tests require accessing a k8s cluster
  doCheck = false;

  meta = with lib; {
    description = "Multus CNI is a container network interface (CNI) plugin for Kubernetes that enables attaching multiple network interfaces to pods";
    homepage = "https://github.com/k8snetworkplumbingwg/multus-cni";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ onixie ];
    mainProgram = "multus";
  };
}
