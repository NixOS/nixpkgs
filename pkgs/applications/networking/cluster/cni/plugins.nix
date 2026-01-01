{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nixosTests,
}:

buildGoModule rec {
  pname = "cni-plugins";
<<<<<<< HEAD
  version = "1.9.0";
=======
  version = "1.8.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "containernetworking";
    repo = "plugins";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-0ZonR8pV20bBbC2AkNCJhoseDVxNwwMa7coD/ON6clA=";
=======
    hash = "sha256-/I2fEVVQ89y8l95Ri0V5qxVj/SzXVqP0IT2vSdz8jC8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    changelog = "https://github.com/containernetworking/plugins/releases/tag/${src.rev}";
    description = "Some standard networking plugins, maintained by the CNI team";
    homepage = "https://www.cni.dev/plugins/";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.podman ];
=======
  meta = with lib; {
    changelog = "https://github.com/containernetworking/plugins/releases/tag/${src.rev}";
    description = "Some standard networking plugins, maintained by the CNI team";
    homepage = "https://www.cni.dev/plugins/";
    license = licenses.asl20;
    platforms = platforms.linux;
    teams = [ teams.podman ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
