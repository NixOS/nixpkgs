{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "multus-cni";
<<<<<<< HEAD
  version = "4.0.2";
=======
  version = "3.9.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "k8snetworkplumbingwg";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-Q6ACXOv1E3Ouki4ksdlUZFbWcDgo9xbCiTfEiVG5l18=";
=======
    sha256 = "sha256-43cFBrFM2jvD/SJ+QT1JQkr593jkdzAAvYlVUAQArEw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  ldflags = [
    "-s"
    "-w"
    "-X=gopkg.in/k8snetworkplumbingwg/multus-cni.v3/pkg/multus.version=${version}"
  ];

<<<<<<< HEAD
  subPackages = [
    "cmd/multus-daemon"
    "cmd/multus-shim"
    "cmd/multus"
    "cmd/thin_entrypoint"
  ];

  vendorHash = null;

  doCheck = true;
=======
  preInstall = ''
    mv $GOPATH/bin/cmd $GOPATH/bin/multus
  '';

  vendorHash = null;

  # Some of the tests require accessing a k8s cluster
  doCheck = false;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Multus CNI is a container network interface (CNI) plugin for Kubernetes that enables attaching multiple network interfaces to pods";
    homepage = "https://github.com/k8snetworkplumbingwg/multus-cni";
    license = licenses.asl20;
    platforms = platforms.linux;
<<<<<<< HEAD
    maintainers = with maintainers; [ onixie kashw2 ];
=======
    maintainers = with maintainers; [ onixie ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    mainProgram = "multus";
  };
}
