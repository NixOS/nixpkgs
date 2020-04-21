{ lib, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  pname = "cni-plugins";
  version = "0.8.5";

  src = fetchFromGitHub {
    owner = "containernetworking";
    repo = "plugins";
    rev = "v${version}";
    sha256 = "17c8pvpn0dpda6ah7irr9hhd8sk7mnm32zv72nc5pxg1xvfpaipi";
  };

  goPackagePath = "github.com/containernetworking/plugins";

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

  meta = with lib; {
    description = "Some standard networking plugins, maintained by the CNI team";
    homepage = "https://github.com/containernetworking/plugins";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cstrahan saschagrunert ];
  };
}
