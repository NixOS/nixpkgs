{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "multus-cni";
  version = "3.7.1";

  src = fetchFromGitHub {
    owner = "k8snetworkplumbingwg";
    repo = pname;
    rev = "v${version}";
    sha256 = "04rn7ypd0cw2c33wqb9wqy1dp6ajvcp7rcv7zybffb1d40mdlds1";
  };

  buildFlagsArray = let
    multus = "gopkg.in/intel/multus-cni.v3/pkg/multus";
    commit = "f6298a3a294a79f9fbda0b8f175e521799d5f8d7";
  in [
    "-ldflags=-s -w -X '${multus}.version=v${version}' -X '${multus}.commit=${commit}'"
  ];

  preInstall = ''
      mv $GOPATH/bin/cmd $GOPATH/bin/multus
  '';

  vendorSha256 = null;

  # Some of the tests require accessing a k8s cluster
  doCheck = false;

  meta = with lib; {
    description = "Multus CNI is a container network interface (CNI) plugin for Kubernetes that enables attaching multiple network interfaces to pods. ";
    homepage = "https://github.com/k8snetworkplumbingwg/multus-cni";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ onixie ];
  };
}
