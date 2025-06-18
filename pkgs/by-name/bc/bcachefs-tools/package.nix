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
  fuse3,
  cargo,
  rustc,
  rustPlatform,
  makeWrapper,
  nix-update-script,
  python3,
  testers,
  nixosTests,
  installShellFiles,
  fuseSupport ? false,
  udevCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bcachefs-tools";
  version = "1.25.2";

  src = fetchFromGitHub {
    owner = "koverstreet";
    repo = "bcachefs-tools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4MscYFlUwGrFhjpQs1ifDMh5j+t9x7rokOtR2SmhCro=";
  };

  nativeBuildInputs = [
    pkg-config
    cargo
    rustc
    rustPlatform.cargoSetupHook
    rustPlatform.bindgenHook
    makeWrapper
    installShellFiles
    udevCheckHook
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

  cargoDeps = rustPlatform.fetchCargoVendor {
    src = finalAttrs.src;
    hash = "sha256-juXRmI3tz2BXQsRaRRGyBaGqeLk2QHfJb2sKPmWur8s=";
  };

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "VERSION=${finalAttrs.version}"
    "INITRAMFS_DIR=${placeholder "out"}/etc/initramfs-tools"

    # Tries to install to the 'systemd-minimal' and 'udev' nix installation paths
    "PKGCONFIG_SERVICEDIR=$(out)/lib/systemd/system"
    "PKGCONFIG_UDEVDIR=$(out)/lib/udev"
  ] ++ lib.optional fuseSupport "BCACHEFS_FUSE=1";

  env = {
    CARGO_BUILD_TARGET = stdenv.hostPlatform.rust.rustcTargetSpec;
    "CARGO_TARGET_${stdenv.hostPlatform.rust.cargoEnvVarTarget}_LINKER" = "${stdenv.cc.targetPrefix}cc";
  };

  # FIXME: Try enabling this once the default linux kernel is at least 6.7
  doCheck = false; # needs bcachefs module loaded on builder

  doInstallCheck = true;

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail "target/release/bcachefs" "target/${stdenv.hostPlatform.rust.rustcTargetSpec}/release/bcachefs"
  '';

  preCheck = lib.optionalString (!fuseSupport) ''
    rm tests/test_fuse.py
  '';
  checkFlags = [ "BCACHEFS_TEST_USE_VALGRIND=no" ];

  postInstall =
    ''
      substituteInPlace $out/libexec/bcachefsck_all \
        --replace-fail "/usr/bin/python3" "${python3.interpreter}"
    ''
    + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      installShellCompletion --cmd bcachefs \
        --bash <($out/sbin/bcachefs completions bash) \
        --zsh  <($out/sbin/bcachefs completions zsh) \
        --fish <($out/sbin/bcachefs completions fish)
    '';

  passthru = {
    tests = {
      version = testers.testVersion {
        package = finalAttrs.finalPackage;
        command = "${finalAttrs.meta.mainProgram} version";
        version = "${finalAttrs.version}";
      };
      smoke-test = nixosTests.bcachefs;
      inherit (nixosTests.installer) bcachefsSimple bcachefsEncrypted bcachefsMulti;
    };

    updateScript = nix-update-script { };
  };

  enableParallelBuilding = true;

  meta = {
    description = "Tool for managing bcachefs filesystems";
    homepage = "https://bcachefs.org/";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [
      davidak
      Madouura
    ];
    platforms = lib.platforms.linux;
    mainProgram = "bcachefs";
  };
})
