{
  lib,
  stdenv,
  fetchFromGitLab,
  cargo,
  docutils,
  meson,
  ninja,
  python3,
  rustc,
  rustPlatform,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libblkio";
  version = "1.5.0";

  src = fetchFromGitLab {
    owner = "libblkio";
    repo = "libblkio";
    tag = "v${finalAttrs.version}";
    hash = "sha256-g1AZnBray3aAg+NQlUrBcYTeKS/zZv8URF/FNDpI/+g=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-o8P+Uu/9jiS/PKf9FmiXthreK+MYa1nPi4eQB648hcE=";
  };

  __structuredAttrs = true;

  nativeBuildInputs = [
    cargo
    docutils # rst2man
    meson
    ninja
    python3 # package-version.py
    rustc
    rustPlatform.cargoSetupHook
  ];

  strictDeps = true;

  postPatch = ''
    patchShebangs package-version.py src/cargo-build.sh
  '';

  doCheck = true;

  # The remaining suites need real hardware (an NVMe namespace, a virtio-blk
  # PCI device, a vDPA device or a running vhost-user server).
  mesonCheckFlags = [
    "--suite"
    "generic"
    "--suite"
    "io_uring+parallel"
  ];

  meta = {
    description = "Library for high-performance disk I/O";
    longDescription = ''
      libblkio provides a fast, block-device-oriented I/O API with drivers for
      Linux io_uring, NVMe io_uring passthrough, and virtio-blk over
      vhost-user, vhost-vdpa and VFIO PCI.
    '';
    homepage = "https://gitlab.com/libblkio/libblkio";
    changelog = "https://gitlab.com/libblkio/libblkio/-/tags/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ Fumesover ];
    platforms = lib.platforms.linux;
  };
})
