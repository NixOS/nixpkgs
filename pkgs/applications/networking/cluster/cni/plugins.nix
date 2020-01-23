{ stdenv, lib, fetchFromGitHub, go, removeReferencesTo, buildGoPackage }:
buildGoPackage rec {
  pname = "cni-plugins";
  version = "0.8.4";

  src = fetchFromGitHub {
    owner = "containernetworking";
    repo = "plugins";
    rev = "v${version}";
    sha256 = "02kz6y3klhbriybsskn4hmldwli28cycnp2klsm2x0y9c73iczdp";
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
