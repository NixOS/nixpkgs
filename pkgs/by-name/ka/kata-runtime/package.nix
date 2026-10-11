# Derived from https://github.com/colemickens/nixpkgs-kubernetes
{
  callPackage,
  cmake,
  fetchFromGitHub,
  lib,
  nix-update-script,
  openssl,
  pkg-config,
  protobuf,
  qemu_kvm,
  rustPlatform,
  stdenv,
  virtiofsd,
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

  # Use the system OpenSSL rather than building the vendored openssl-src
  env.OPENSSL_NO_VENDOR = 1;

  # cmake is only needed by the zlib-ng build of libz-sys
  dontUseCmakeConfigure = true;

  # Cargo is invoked by the upstream Makefile
  dontCargoBuild = true;
  dontCargoInstall = true;
  dontCargoCheck = true;

  # https://github.com/NixOS/nixpkgs/issues/25959
  hardeningDisable = [ "fortify" ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "BINDIR=${placeholder "out"}/bin"
    "HYPERVISOR=qemu"
    "LIBC=gnu"
    "QEMUPATH=${qemu_kvm}/bin/${qemuSystemBinary}"
    # OpenVMM is Azure specific, and the openvmm package is too outdated (0-unstable-2025-03-13) to be used here
    "USE_OPENVMM=false"
  ];

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
