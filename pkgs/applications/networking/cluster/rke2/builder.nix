lib:
{
  rke2Version,
  rke2Commit,
  rke2TarballHash,
  rke2VendorHash,
  updateScript,
  k8sImageTag,
  etcdVersion,
  pauseVersion,
  ccmVersion,
  dockerizedVersion,
  imagesVersions,
}:

# Build dependencies
{
  lib,
  stdenv,
  buildGoModule,
  go,
  makeWrapper,
  fetchzip,
  fetchurl,

  # Runtime dependencies
  procps,
  coreutils,
  util-linux,
  ethtool,
  socat,
  iptables,
  bridge-utils,
  iproute2,
  kmod,
  lvm2,

  # Killall Script dependencies
  systemd,
  gnugrep,
  gnused,

  # Testing dependencies
  nixosTests,
  testers,
}:
buildGoModule (finalAttrs: {
  pname = "rke2";
  version = rke2Version;

  src = fetchzip {
    url = "https://github.com/rancher/rke2/archive/refs/tags/v${rke2Version}.tar.gz";
    hash = "${rke2TarballHash}";
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

  # Passing boringcrypto to GOEXPERIMENT variable to build with goboring library
  GOEXPERIMENT = "boringcrypto";

  # See: https://github.com/rancher/rke2/blob/e7f87c6dd56fdd76a7dab58900aeea8946b2c008/scripts/build-binary#L27-L38
  ldflags = [
    "-w"
    "-X github.com/k3s-io/k3s/pkg/version.GitCommit=${lib.substring 0 6 rke2Commit}"
    "-X github.com/k3s-io/k3s/pkg/version.Program=${finalAttrs.pname}"
    "-X github.com/k3s-io/k3s/pkg/version.Version=v${finalAttrs.version}"
    "-X github.com/k3s-io/k3s/pkg/version.UpstreamGolang=go${go.version}"
    "-X github.com/rancher/rke2/pkg/images.DefaultRegistry=docker.io"
    "-X github.com/rancher/rke2/pkg/images.DefaultEtcdImage=rancher/hardened-etcd:${etcdVersion}"
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
      --prefix PATH : ${lib.makeBinPath finalAttrs.buildInputs}

    install -D ./bundle/bin/rke2-killall.sh $out/bin/rke2-killall.sh
    wrapProgram $out/bin/rke2-killall.sh \
      --prefix PATH : ${
        lib.makeBinPath [
          systemd
          gnugrep
          gnused
        ]
      } \
      --prefix PATH : ${lib.makeBinPath finalAttrs.buildInputs}
  '';

  doCheck = false;

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    # Verify that the binary uses BoringCrypto
    go tool nm $out/bin/.rke2-wrapped | grep '_Cfunc__goboringcrypto_' > /dev/null
    runHook postInstallCheck
  '';

  passthru = {
    inherit updateScript;
    tests =
      let
        moduleTests =
          let
            package_version =
              "rke2_" + lib.replaceStrings [ "." ] [ "_" ] (lib.versions.majorMinor rke2Version);
          in
          lib.mapAttrs (name: value: nixosTests.rke2.${name}.${package_version}) nixosTests.rke2;
      in
      {
        version = testers.testVersion {
          package = finalAttrs.finalPackage;
          version = "v${finalAttrs.version}";
        };
      }
      // moduleTests;
  }
  // (lib.mapAttrs (_: value: fetchurl value) imagesVersions);

  meta = {
    homepage = "https://github.com/rancher/rke2";
    description = "Rancher's next-generation Kubernetes distribution, also known as RKE Government";
    changelog = "https://github.com/rancher/rke2/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      azey7f
      rorosen
      zimbatm
      zygot
    ];
    mainProgram = "rke2";
    platforms = lib.platforms.linux;
  };
})
