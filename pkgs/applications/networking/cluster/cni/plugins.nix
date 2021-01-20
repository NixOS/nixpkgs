{ lib, fetchFromGitHub, buildGoModule, nixosTests }:

buildGoModule rec {
  pname = "cni-plugins";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "containernetworking";
    repo = "plugins";
    rev = "v${version}";
    sha256 = "1nkaspz96yglq1fr8a3xr39qmbs98pk7qpqav3cfd82qwbq7vs06";
  };

  vendorSha256 = null;

  doCheck = false;

  buildFlagsArray = [
    "-ldflags=-X github.com/containernetworking/plugins/pkg/utils/buildversion.BuildVersion=v${version}"
  ];

  subPackages = [
    "plugins/ipam/dhcp"
    "plugins/ipam/host-local"
    "plugins/ipam/static"
    "plugins/main/bridge"
    "plugins/main/host-device"
    "plugins/main/ipvlan"
    "plugins/main/loopback"
    "plugins/main/macvlan"
    "plugins/main/ptp"
    "plugins/main/vlan"
    "plugins/meta/bandwidth"
    "plugins/meta/firewall"
    "plugins/meta/flannel"
    "plugins/meta/portmap"
    "plugins/meta/sbr"
    "plugins/meta/tuning"
    "plugins/meta/vrf"
  ];

  passthru.tests = { inherit (nixosTests) cri-o podman; };

  meta = with lib; {
    description = "Some standard networking plugins, maintained by the CNI team";
    homepage = "https://www.cni.dev/plugins/";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cstrahan ] ++ teams.podman.members;
  };
}
