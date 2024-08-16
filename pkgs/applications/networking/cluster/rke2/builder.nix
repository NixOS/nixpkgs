lib: { rke2Version, rke2RepoSha256, rke2VendorHash, updateScript

, rke2Commit, k8sImageTag, etcdVersion, pauseVersion, ccmVersion, dockerizedVersion, ... }:

{ lib, stdenv, buildGoModule, go, fetchgit, makeWrapper

# Runtime dependencies
, procps, coreutils, util-linux, ethtool, socat, iptables, bridge-utils, iproute2, kmod, lvm2

# Killall Script dependencies
, systemd, gnugrep, gnused

# Testing dependencies
, nixosTests, testers, rke2
}:

buildGoModule rec {
  pname = "rke2";
  version = rke2Version;

  src = fetchgit {
    url = "https://github.com/rancher/rke2.git";
    rev = "v${version}";
    sha256 = rke2RepoSha256;
  };

  vendorHash = rke2VendorHash;

  nativeBuildInputs = [ makeWrapper ];

  # Important utilities used by the kubelet.
  # See: https://github.com/kubernetes/kubernetes/issues/26093#issuecomment-237202494
  # Notice the list in that issue is stale, but as a redundancy reservation.
  buildInputs = [
    procps # pidof pkill
    coreutils # uname touch env nice du
    util-linux # lsblk fsck mkfs nsenter mount umount
    ethtool # ethtool
    socat # socat
    iptables # iptables iptables-restore iptables-save
    bridge-utils # brctl
    iproute2 # ip tc
    kmod # modprobe
    lvm2 # dmsetup
  ];

  # See: https://github.com/rancher/rke2/blob/e7f87c6dd56fdd76a7dab58900aeea8946b2c008/scripts/build-binary#L27-L38
  ldflags = [
    "-w"
    "-X github.com/k3s-io/k3s/pkg/version.GitCommit=${lib.substring 0 6 rke2Commit}"
    "-X github.com/k3s-io/k3s/pkg/version.Program=${pname}"
    "-X github.com/k3s-io/k3s/pkg/version.Version=v${version}"
    "-X github.com/k3s-io/k3s/pkg/version.UpstreamGolang=go${go.version}"
    "-X github.com/rancher/rke2/pkg/images.DefaultRegistry=docker.io"
    "-X github.com/rancher/rke2/pkg/images.DefaultEtcdImage=rancher/hardened-etcd:${etcdVersion}-build20240418"
    "-X github.com/rancher/rke2/pkg/images.DefaultKubernetesImage=rancher/hardened-kubernetes:${k8sImageTag}"
    "-X github.com/rancher/rke2/pkg/images.DefaultPauseImage=rancher/mirrored-pause:${pauseVersion}"
    "-X github.com/rancher/rke2/pkg/images.DefaultRuntimeImage=rancher/rke2-runtime:${dockerizedVersion}"
    "-X github.com/rancher/rke2/pkg/images.DefaultCloudControllerManagerImage=rancher/rke2-cloud-provider:${ccmVersion}"
  ];

  tags = [
    "no_cri_dockerd"
    "no_embedded_executor"
    "no_stage"
    "sqlite_omit_load_extension"
    "selinux"
    "netgo"
    "osusergo"
  ];

  subPackages = [ "." ];

  installPhase = ''
    install -D $GOPATH/bin/rke2 $out/bin/rke2
    wrapProgram $out/bin/rke2 \
      --prefix PATH : ${lib.makeBinPath buildInputs}

    install -D ./bundle/bin/rke2-killall.sh $out/bin/rke2-killall.sh
    wrapProgram $out/bin/rke2-killall.sh \
      --prefix PATH : ${lib.makeBinPath [ systemd gnugrep gnused ]} \
      --prefix PATH : ${lib.makeBinPath buildInputs}
  '';

  doCheck = false;

  passthru.updateScript = updateScript;

  passthru.tests = {
    version = testers.testVersion {
      package = rke2;
      version = "v${version}";
    };
  } // lib.optionalAttrs stdenv.isLinux {
    inherit (nixosTests) rke2;
  };

  meta = with lib; {
    homepage = "https://github.com/rancher/rke2";
    description = "RKE2, also known as RKE Government, is Rancher's next-generation Kubernetes distribution";
    changelog = "https://github.com/rancher/rke2/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ zimbatm zygot ];
    mainProgram = "rke2";
    platforms = platforms.linux;
  };
}
