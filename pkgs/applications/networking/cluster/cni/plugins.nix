{ lib, fetchFromGitHub, buildGoModule, nixosTests }:

buildGoModule rec {
  pname = "cni-plugins";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "containernetworking";
    repo = "plugins";
    rev = "v${version}";
    hash = "sha256-thtN7po5SToM0ZFYIbycaPJTafLvk9hFV4XFGOpWmpg=";
  };

  vendorHash = null;

  doCheck = false;

  ldflags = [
    "-X github.com/containernetworking/plugins/pkg/utils/buildversion.BuildVersion=v${version}"
  ];

  subPackages = [
    "plugins/ipam/dhcp"
    "plugins/ipam/host-local"
    "plugins/ipam/static"
    "plugins/main/bridge"
    "plugins/main/dummy"
    "plugins/main/host-device"
    "plugins/main/ipvlan"
    "plugins/main/loopback"
    "plugins/main/macvlan"
    "plugins/main/ptp"
    "plugins/main/tap"
    "plugins/main/vlan"
    "plugins/meta/bandwidth"
    "plugins/meta/firewall"
    "plugins/meta/portmap"
    "plugins/meta/sbr"
    "plugins/meta/tuning"
    "plugins/meta/vrf"
  ];

  passthru.tests = { inherit (nixosTests) cri-o; };

  meta = with lib; {
    changelog = "https://github.com/containernetworking/plugins/releases/tag/${src.rev}";
    description = "Some standard networking plugins, maintained by the CNI team";
    homepage = "https://www.cni.dev/plugins/";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ] ++ teams.podman.members;
  };
}
