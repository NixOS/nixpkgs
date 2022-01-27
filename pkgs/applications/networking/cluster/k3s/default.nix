{ stdenv
, lib
, makeWrapper
, socat
, iptables
, iproute2
, bridge-utils
, conntrack-tools
, buildGoModule
, buildGoPackage
, runc
, kmod
, libseccomp
, pkg-config
, ethtool
, util-linux
, fetchFromGitHub
, fetchurl
, fetchzip
, fetchgit
, zstd
, nixosTests
}:

with lib;

let
  k3sVersion = "1.23.3+k3s1";     # k3s git tag
  k3sCommit = "5fb370e53e0014dc96183b8ecb2c25a61e891e76"; # k3s git commit at the above version
  k3sRepoSha256 = "0vlsqy4iccjmf4nslmr0a7w5pbb4891j2qk5dr5fsbvgdnq6xm6i";

  traefikChartVersion = "10.9.1"; # taken from ./manifests/traefik.yaml at spec.chart
  traefikChartSha256 = "0r5qs378g1dl7w7kmc8pd39za2vj7ga6qyg02l233mylhwp47kaw";

  k3sRootVersion = "0.9.1";       # taken from ./scripts/version.sh at VERSION_ROOT
  k3sRootSha256 = "0r2cj4l50cxkrvszpzxfk36lvbjf9vcmp6d5lvxg8qsah8lki3x8";

  k3sCNIVersion = "0.9.1-k3s1";   # taken from ./scripts/version.sh at VERSION_CNIPLUGINS
  k3sCNISha256 = "1327vmfph7b8i14q05c2xdfzk60caflg1zhycx0mrf3d59f4zsz5";

  baseMeta = {
    description = "A lightweight Kubernetes distribution";
    license = licenses.asl20;
    homepage = "https://k3s.io";
    maintainers = with maintainers; [ euank ];
    platforms = platforms.linux;
  };

  k3sRepo = fetchgit {
    url = "https://github.com/k3s-io/k3s";
    rev = "v${k3sVersion}";
    sha256 = k3sRepoSha256;
  };
in

    buildGoModule rec {
      name = "k3s";
      version = k3sVersion;

      src = k3sRepo;

      vendorSha256 = "sha256-9+2k/ipAOhc8JJU+L2dwaM01Dkw+0xyrF5kt6mL19G0=";

      subPackages = [ "." ];
      # subPackages = [ "cmd/server/" ];

      ldflags = [
        "-w -s"
      ];
      extldflags = [
        "-static"
        "-lm"
        "-ldl"
        "-lz"
        "-lpthread"
      ];

      # "apparmor seccomp netcgo osusergo providerless"

      nativeBuildInputs = [ makeWrapper ];

      postInstall = ''
        for appname in agent certificate etcd-snapshot secrets-encrypt server ; do
          makeWrapper $out/bin/k3s $out/bin/k3s-$appname --argv0 $appname --add-flags $appname
        done

        for appname in kubectl crictl ctr ; do
          makeWrapper $out/bin/k3s $out/bin/$appname --argv0 $appname
        done
      '';

      passthru.tests = { inherit (nixosTests) k3s-single-node k3s-single-node-docker; };

      meta = baseMeta // {

        description = "The various binaries that get packaged into the final k3s binary";
      };
    }
