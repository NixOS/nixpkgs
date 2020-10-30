{ lib, fetchFromGitHub, buildGoModule, nixosTests }:

buildGoModule rec {
  pname = "cni-plugins";
  version = "0.8.7";

  src = fetchFromGitHub {
    owner = "containernetworking";
    repo = "plugins";
    rev = "v${version}";
    sha256 = "1sjk0cghldygx1jgx4bqv83qky7shk64n6xkkfxl92f12wyvsq9j";
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
  ];

  passthru.tests = { inherit (nixosTests) cri-o podman; };

  meta = with lib; {
    description = "Some standard networking plugins, maintained by the CNI team";
    homepage = "https://github.com/containernetworking/plugins";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cstrahan ] ++ teams.podman.members;
  };
}
