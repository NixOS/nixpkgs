# Derived from https://github.com/colemickens/nixpkgs-kubernetes
{
  buildGoModule,
  callPackage,
  fetchFromGitHub,
  lib,
  qemu_kvm,
  stdenv,
  virtiofsd,
  yq-go,
}:

let
  version = "3.16.0";

  kata-images = callPackage ./kata-images.nix { inherit version; };

  qemuSystemBinary =
    {
      "x86_64-linux" = "qemu-system-x86_64";
      "aarch64-linux" = "qemu-system-aarch64";
    }
    ."${stdenv.hostPlatform.system}" or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

in
buildGoModule rec {
  pname = "kata-runtime";
  inherit version;

  # https://github.com/NixOS/nixpkgs/issues/25959
  hardeningDisable = [ "fortify" ];

  src = fetchFromGitHub {
    owner = "kata-containers";
    repo = "kata-containers";
    rev = version;
    hash = "sha256-+SppAF77NbXlSrBGvIm40AmNC12GrexbX7fAPBoDAcs=";
  };

  sourceRoot = "${src.name}/src/runtime";

  vendorHash = null;

  dontConfigure = true;

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "DEFAULT_HYPERVISOR=qemu"
    "HYPERVISORS=qemu"
    "QEMUPATH=${qemu_kvm}/bin/${qemuSystemBinary}"
  ];

  buildPhase = ''
    runHook preBuild
    mkdir -p $TMPDIR/gopath/bin
    ln -s ${yq-go}/bin/yq $TMPDIR/gopath/bin/yq
    HOME=$TMPDIR GOPATH=$TMPDIR/gopath make ${toString makeFlags}
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    HOME=$TMPDIR GOPATH=$TMPDIR/gopath make ${toString makeFlags} install
    ln -s $out/bin/containerd-shim-kata-v2 $out/bin/containerd-shim-kata-qemu-v2
    ln -s $out/bin/containerd-shim-kata-v2 $out/bin/containerd-shim-kata-clh-v2

    # Update a few paths to the Nix-provided versions: kata-images, virtiofsd, and qemu_kvm
    sed -i \
      -e "s!$out/share/kata-containers!${kata-images}/share/kata-containers!" \
      -e "s!^virtio_fs_daemon.*!virtio_fs_daemon=\"${virtiofsd}/bin/virtiofsd\"!" \
      -e "s!^valid_virtio_fs_daemon_paths.*!valid_virtio_fs_daemon_paths=[\"${qemu_kvm}/libexec/virtiofsd\"]!" \
      "$out/share/defaults/kata-containers/"*.toml

    runHook postInstall
  '';

  passthru = {
    inherit kata-images;
  };

  meta = {
    description = "Lightweight Virtual Machines like containers that provide the workload isolation and security of VMs";
    homepage = "https://github.com/kata-containers/kata-containers";
    changelog = "https://github.com/kata-containers/kata-containers/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ thomasjm ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
}
