{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  libuuid,
  libsodium,
  keyutils,
  liburcu,
  zlib,
  libaio,
  zstd,
  lz4,
  attr,
  udev,
  nixosTests,
  fuse3,
  cargo,
  rustc,
  rustPlatform,
  makeWrapper,
  nix-update-script,
  python3,
  fetchpatch,
  fuseSupport ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bcachefs-tools";
  version = "1.9.2";

  src = fetchFromGitHub {
    owner = "koverstreet";
    repo = "bcachefs-tools";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-1GsRBAVAfD0SAM1gk8W+bX7MtxunGKOLtXweL4rrf9Q=";
  };

  nativeBuildInputs = [
    pkg-config
    cargo
    rustc
    rustPlatform.cargoSetupHook
    rustPlatform.bindgenHook
    makeWrapper
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
  ] ++ lib.optional fuseSupport fuse3;

  cargoDeps = rustPlatform.fetchCargoTarball {
    src = finalAttrs.src;
    hash = "sha256-rabiNqw4hg0Js8VadxfkhNLIsrKfMuoKa5lFIfSMNPY=";
  };

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "VERSION=${finalAttrs.version}"
    "INITRAMFS_DIR=${placeholder "out"}/etc/initramfs-tools"
  ] ++ lib.optional fuseSupport "BCACHEFS_FUSE=1";

  env = {
    CARGO_BUILD_TARGET = stdenv.hostPlatform.rust.rustcTargetSpec;
    "CARGO_TARGET_${stdenv.hostPlatform.rust.cargoEnvVarTarget}_LINKER" = "${stdenv.cc.targetPrefix}cc";
  };

  # FIXME: Try enabling this once the default linux kernel is at least 6.7
  doCheck = false; # needs bcachefs module loaded on builder

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail "target/release/bcachefs" "target/${stdenv.hostPlatform.rust.rustcTargetSpec}/release/bcachefs"
  '';

  preCheck = lib.optionalString (!fuseSupport) ''
    rm tests/test_fuse.py
  '';
  checkFlags = [ "BCACHEFS_TEST_USE_VALGRIND=no" ];

  # Tries to install to the 'systemd-minimal' and 'udev' nix installation paths
  installFlags = [
    "PKGCONFIG_SERVICEDIR=$(out)/lib/systemd/system"
    "PKGCONFIG_UDEVDIR=$(out)/lib/udev"
  ];

  postInstall = ''
    substituteInPlace $out/libexec/bcachefsck_all \
      --replace-fail "/usr/bin/python3" "${python3}/bin/python3"
  '';

  passthru = {
    tests = {
      smoke-test = nixosTests.bcachefs;
      inherit (nixosTests.installer) bcachefsSimple bcachefsEncrypted bcachefsMulti;
    };

    updateScript = nix-update-script {};
  };

  enableParallelBuilding = true;

  meta = {
    description = "Tool for managing bcachefs filesystems";
    homepage = "https://bcachefs.org/";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [
      davidak
      johnrtitor
      Madouura
    ];
    platforms = lib.platforms.linux;
  };
})
