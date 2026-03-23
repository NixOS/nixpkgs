{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  libuuid,
  libsodium,
  keyutils,
  kmod,
  liburcu,
  zlib,
  libaio,
  zstd,
  lz4,
  attr,
  udev,
  fuse3,
  cargo,
  rustc,
  rustPlatform,
  makeWrapper,
  nix-update-script,
  versionCheckHook,
  nixosTests,
  installShellFiles,
  fuseSupport ? false,
  udevCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bcachefs-tools";
  version = "1.37.3";

  src = fetchFromGitHub {
    owner = "koverstreet";
    repo = "bcachefs-tools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cFqjht3mNzvvd9itIkc271iYfb2sfezWtC98jz0vD+I=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    hash = "sha256-ivJntxMIx8R2ytCr1ja2pQIXqjkQ12w9OhVh5YWsFFM=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail "target/release/bcachefs" "target/${stdenv.hostPlatform.rust.rustcTargetSpec}/release/bcachefs"

    substituteInPlace src/commands/mount.rs \
      --replace-fail 'std::process::Command::new("modprobe")' 'std::process::Command::new("${lib.getExe' kmod "modprobe"}")'
  '';

  nativeBuildInputs = [
    pkg-config
    cargo
    rustc
    rustPlatform.cargoSetupHook
    rustPlatform.bindgenHook
    makeWrapper
    installShellFiles
  ];

  buildInputs = [
    libaio
    keyutils
    lz4
    libsodium
    liburcu
    libuuid
    zstd
    zlib
    attr
    udev
  ]
  ++ lib.optional fuseSupport fuse3;

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "VERSION=${finalAttrs.version}"
    "INITRAMFS_DIR=${placeholder "out"}/etc/initramfs-tools"
    "DKMSDIR=${placeholder "dkms"}"

    # Tries to install to the 'systemd-minimal' and 'udev' nix installation paths
    "PKGCONFIG_SERVICEDIR=$(out)/lib/systemd/system"
    "PKGCONFIG_UDEVDIR=$(out)/lib/udev"
  ]
  ++ lib.optional fuseSupport "BCACHEFS_FUSE=1";

  enableParallelBuilding = true;

  installFlags = [
    "install"
    "install_dkms"
  ];

  env = {
    CARGO_BUILD_TARGET = stdenv.hostPlatform.rust.rustcTargetSpec;
    "CARGO_TARGET_${stdenv.hostPlatform.rust.cargoEnvVarTarget}_LINKER" = "${stdenv.cc.targetPrefix}cc";
  };

  # FIXME: Try enabling this once the default linux kernel is at least 6.7
  doCheck = false; # needs bcachefs module loaded on builder

  preCheck = lib.optionalString (!fuseSupport) ''
    rm tests/test_fuse.py
  '';
  checkFlags = [ "BCACHEFS_TEST_USE_VALGRIND=no" ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    udevCheckHook
    versionCheckHook
  ];
  versionCheckProgramArg = "version";

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd bcachefs \
      --bash <($out/sbin/bcachefs completions bash) \
      --zsh  <($out/sbin/bcachefs completions zsh) \
      --fish <($out/sbin/bcachefs completions fish)
  '';

  outputs = [
    "out"
    "dkms"
  ];

  passthru = {
    # See NOTE in linux-kernels.nix
    kernelModule = import ./kernel-module.nix finalAttrs.finalPackage;

    tests = {
      smoke-test = nixosTests.bcachefs;
      inherit (nixosTests.installer) bcachefsSimple bcachefsEncrypted bcachefsMulti;
    };

    updateScript = nix-update-script { };
  };

  meta = {
    description = "Tool for managing bcachefs filesystems";
    homepage = "https://bcachefs.org/";
    downloadPage = "https://github.com/koverstreet/bcachefs-tools";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [
      davidak
      johnrtitor
    ];
    platforms = lib.platforms.linux;
    mainProgram = "bcachefs";
    broken = stdenv.hostPlatform.isi686; # error: stack smashing detected
  };
})
