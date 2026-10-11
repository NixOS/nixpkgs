# Derived from https://github.com/colemickens/nixpkgs-kubernetes
{
  OVMF,
  callPackage,
  cloud-hypervisor,
  cmake,
  fetchFromGitHub,
  lib,
  nix-update-script,
  openssl,
  pkg-config,
  protobuf,
  qemu_kvm,
  rustPlatform,
  shadow,
  stdenv,
  virtiofsd,
  # Build the built-in Dragonball hypervisor.
  withDragonball ? true,
  # Replace the hardcoded /usr/sbin/{useradd,userdel,nologin} paths used by
  # rootless hypervisors with the ones from `shadow`. This patches the source.
  patchShadowPaths ? false,
  # Rootless hypervisors normally get a throwaway user from useradd for each
  # sandbox. Set e.g. `{ prefix = "kata-vmm-"; size = 32; }` to instead pick
  # one of the users `<prefix>0` .. `<prefix><size - 1>`, which must already
  # exist, for hosts where /etc/passwd can't be modified at runtime (NixOS with
  # `users.mutableUsers = false`). An optional `lockDir` sets the directory
  # holding the lock files (default: /run/kata-vmm-users).
  # This patches the source.
  vmmUserPool ? null,
}:

let
  version = "4.2.0";

  kata-images-all = callPackage ./kata-images.nix { inherit version; };

  kata-images =
    kata-images-all.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  qemuSystemBinary =
    {
      "x86_64-linux" = "qemu-system-x86_64";
      "aarch64-linux" = "qemu-system-aarch64";
    }
    ."${stdenv.hostPlatform.system}" or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kata-runtime";
  inherit version;

  src = fetchFromGitHub {
    owner = "kata-containers";
    repo = "kata-containers";
    rev = version;
    hash = "sha256-afEm5lcXD4qC2Ezhx7wyZXD5pj4uLPoSnJrvFJL+7qU=";
  };

  # runtime-rs is a member of the Cargo workspace at the repository root,
  # the Makefile is driven from its own subdirectory.
  cargoHash = "sha256-wbMkdNZwvqjey33//iLUG7cVeO+iEexsDVmIW4gvV0o=";

  nativeBuildInputs = [
    cmake
    pkg-config
    protobuf
  ];

  buildInputs = [ openssl ];

  # cmake is only needed by the zlib-ng build of libz-sys
  dontUseCmakeConfigure = true;

  # Cargo is invoked by the upstream Makefile
  dontCargoBuild = true;
  dontCargoInstall = true;
  dontCargoCheck = true;

  # https://github.com/NixOS/nixpkgs/issues/25959
  hardeningDisable = [ "fortify" ];

  patches = lib.optional (vmmUserPool != null) ./vmm-user-pool.patch;

  postPatch = lib.optionalString patchShadowPaths ''
    substituteInPlace src/runtime-rs/crates/hypervisor/src/utils.rs \
      --replace-fail '&["/usr/sbin/useradd", "/sbin/useradd", "/bin/useradd"]' '&["${lib.getExe' shadow "useradd"}"]' \
      --replace-fail '&["/usr/sbin/userdel", "/sbin/userdel", "/bin/userdel"]' '&["${lib.getExe' shadow "userdel"}"]' \
      --replace-fail '&["/usr/sbin/nologin", "/sbin/nologin", "/bin/nologin"]' '&["${lib.getExe' shadow "nologin"}"]'
  '';

  env = {
    # Use the system OpenSSL rather than building the vendored openssl-src
    OPENSSL_NO_VENDOR = 1;
  }
  // lib.optionalAttrs (vmmUserPool != null) (
    {
      KATA_VMM_USER_POOL_PREFIX = vmmUserPool.prefix;
      KATA_VMM_USER_POOL_SIZE = toString vmmUserPool.size;
    }
    // lib.optionalAttrs (vmmUserPool ? lockDir) {
      KATA_VMM_USER_POOL_LOCK_DIR = vmmUserPool.lockDir;
    }
  );

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "BINDIR=${placeholder "out"}/bin"
    "HYPERVISOR=qemu"
    "LIBC=gnu"
    "QEMUPATH=${qemu_kvm}/bin/${qemuSystemBinary}"
    "CLHBINDIR=${lib.getBin cloud-hypervisor}/bin"
    # Upstream doesn't set this on aarch64, which drops the cloud-hypervisor configuration
    "CLHCMD=cloud-hypervisor"
    # OpenVMM is Azure specific, and the openvmm package is too outdated (0-unstable-2025-03-13) to be used here
    "USE_OPENVMM=false"
  ]
  ++ lib.optionals stdenv.hostPlatform.isAarch64 [
    # Upstream sets the aarch64 UEFI firmware for every hypervisor, but cloud-hypervisor
    # and Dragonball refuse a firmware next to a kernel. It is added back for qemu in installPhase.
    "FIRMWAREPATH="
    # Dragonball only has MMIO devices in the aarch64 device tree, so the PCI root
    # disk never shows up, see https://github.com/kata-containers/kata-containers/issues/13768.
    # Drop once https://github.com/kata-containers/kata-containers/pull/13769 is released.
    "VMROOTFSDRIVER_DB=virtio-blk-mmio"
    "DEFBLOCKSTORAGEDRIVER_DB=virtio-blk-mmio"
  ]
  ++ lib.optional (!withDragonball) "USE_BUILTIN_DB=false";

  preBuild = ''
    cd src/runtime-rs
  '';

  buildPhase = ''
    runHook preBuild
    make ${toString finalAttrs.makeFlags}
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    make ${toString finalAttrs.makeFlags} install

    ln -s $out/bin/containerd-shim-kata-v2 $out/bin/containerd-shim-kata-qemu-v2
    ln -s $out/bin/containerd-shim-kata-v2 $out/bin/containerd-shim-kata-clh-v2

    # Update a few paths to the Nix-provided versions: kata-images, virtiofsd, and qemu_kvm
    sed -i \
      -e "s!$out/share/kata-containers!${kata-images}/share/kata-containers!" \
      -e "s!^virtio_fs_daemon.*!virtio_fs_daemon=\"${virtiofsd}/bin/virtiofsd\"!" \
      -e "s!^valid_virtio_fs_daemon_paths.*!valid_virtio_fs_daemon_paths=[\"${qemu_kvm}/libexec/virtiofsd\"]!" \
      "$out/share/defaults/kata-containers/runtime-rs/"configuration-*.toml
  ''
  + lib.optionalString stdenv.hostPlatform.isAarch64 ''
    # Cleared with FIRMWAREPATH= above, only qemu gets the UEFI firmware
    sed -i 's!^firmware = ""!firmware = "${OVMF.fd}/FV/AAVMF_CODE.fd"!' \
      "$out/share/defaults/kata-containers/runtime-rs/"configuration-qemu*.toml
  ''
  + ''
    runHook postInstall
  '';

  passthru = {
    inherit kata-images;
    kata-images-aarch64-linux = kata-images-all.aarch64-linux;
    kata-images-x86_64-linux = kata-images-all.x86_64-linux;
    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage=kata-images-aarch64-linux"
        "--subpackage=kata-images-x86_64-linux"
      ];
    };
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
})
