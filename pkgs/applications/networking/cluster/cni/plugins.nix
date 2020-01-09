{ stdenv, lib, fetchFromGitHub, go, removeReferencesTo, buildGoPackage }:
buildGoPackage rec {
  pname = "cni-plugins";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "containernetworking";
    repo = "plugins";
    rev = "v${version}";
    sha256 = "0dc4fs08x4x518yhgvq3drjvansnc0cb8rm4h5wiw7k3whjii3cd";
  };

  goDeps = ./plugins-deps.nix;
  goPackagePath = "github.com/containernetworking/plugins";
  subPackages = [
    "plugins/meta/bandwidth"
    "plugins/meta/firewall"
    "plugins/meta/flannel"
    "plugins/meta/portmap"
    "plugins/meta/sbr"
    "plugins/meta/tuning"
    "plugins/main/bridge"
    "plugins/main/host-device"
    "plugins/main/ipvlan"
    "plugins/main/loopback"
    "plugins/main/macvlan"
    "plugins/main/ptp"
    "plugins/main/vlan"
    "plugins/ipam/dhcp"
    "plugins/ipam/host-local"
    "plugins/ipam/static"
  ];
  meta = with lib; {
    description = "Some standard networking plugins, maintained by the CNI team";
    homepage = https://github.com/containernetworking/plugins;
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cstrahan saschagrunert ];
  };
}
