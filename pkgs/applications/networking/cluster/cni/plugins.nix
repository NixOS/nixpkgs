{ stdenv, lib, fetchFromGitHub, go, removeReferencesTo, buildGoPackage }:
buildGoPackage rec {
  pname = "cni-plugins";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "containernetworking";
    repo = "plugins";
    rev = "v${version}";
    sha256 = "07d8knnabfjipzvcqbq7h8gd940lln934xp57nf5x31d3hpmvzws";
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
    maintainers = with maintainers; [ cstrahan ];
  };
}
