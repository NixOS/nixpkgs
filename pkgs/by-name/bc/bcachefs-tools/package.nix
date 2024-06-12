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
  fuseSupport ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bcachefs-tools";
  version = "1.7.0-unstable-2024-05-09";

  src = fetchFromGitHub {
    owner = "koverstreet";
    repo = "bcachefs-tools";
    # FIXME: switch to a tagged release once available > 1.7.0
    # Fix for https://github.com/NixOS/nixpkgs/issues/313350
    rev = "3ac510f6a41feb1b695381fa30869d557c00b822";
    hash = "sha256-ZmkeYPiCy7vkXnMFbtUF4761K+I+Ef7UbmSY7dJG09U=";
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
    hash = "sha256-RsRz/nb8L+pL1U4l6RnvqeDFddPvcBFH4wdV7G60pxA=";
  };

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "VERSION=${finalAttrs.version}"
    "INITRAMFS_DIR=${placeholder "out"}/etc/initramfs-tools"
  ] ++ lib.optional fuseSupport "BCACHEFS_FUSE=1";

  # FIXME: Try enabling this once the default linux kernel is at least 6.7
  doCheck = false; # needs bcachefs module loaded on builder

  patches = [
    # code refactoring of bcachefs-tools broke reading passphrases from stdin (vs. terminal)
    # upstream issue https://github.com/koverstreet/bcachefs-tools/issues/261
    ./fix-encrypted-boot.patch
  ];

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
