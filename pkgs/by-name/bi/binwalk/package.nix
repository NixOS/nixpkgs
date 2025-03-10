{
  bzip2,
  cabextract,
  dmg2img,
  dtc,
  dumpifs,
  enableUnfree ? false,
  fetchFromGitHub,
  fontconfig,
  gnutar,
  jefferson,
  lib,
  lzfse,
  lzo,
  lzop,
  lz4,
  openssl_3,
  pkg-config,
  python3,
  rustPlatform,
  sasquatch,
  sleuthkit,
  srec2bin,
  stdenv,
  ubi_reader,
  ucl,
  uefi-firmware-parser,
  unrar,
  unyaffs,
  unzip,
  versionCheckHook,
  vmlinux-to-elf,
  xz,
  zlib,
  zstd,
  _7zz,
}:

rustPlatform.buildRustPackage rec {
  pname = "binwalk";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "ReFirmLabs";
    repo = "binwalk";
    tag = "v${version}";
    hash = "sha256-em+jOnhCZH5EEJrhXTHmxiwpMcBr5oNU1+5IJ1H/oco=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-cnJVeuvNNApEHqgZDcSgqkH3DKAr8+HkqXUH9defTCA=";

  nativeBuildInputs = [ pkg-config ];

  # https://github.com/ReFirmLabs/binwalk/commits/master/dependencies
  buildInputs = [
    bzip2
    cabextract
    dmg2img
    dtc
    dumpifs
    fontconfig
    gnutar
    jefferson
    lzfse
    lzo
    lzop
    lz4
    openssl_3
    python3.pkgs.python-lzo
    sasquatch
    sleuthkit
    srec2bin
    ubi_reader
    ucl
    uefi-firmware-parser
    unyaffs
    unzip
    vmlinux-to-elf
    xz
    zlib
    zstd
    _7zz
  ] ++ lib.optionals enableUnfree [ unrar ];

  # skip broken tests
  checkFlags =
    [
      "--skip=binwalk::Binwalk"
      "--skip=binwalk::Binwalk::scan"
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      "--skip=binwalk::Binwalk::analyze"
      "--skip=binwalk::Binwalk::extract"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      "--skip=extractors::common::Chroot::append_to_file"
      "--skip=extractors::common::Chroot::carve_file"
      "--skip=extractors::common::Chroot::create_block_device"
      "--skip=extractors::common::Chroot::create_character_device"
      "--skip=extractors::common::Chroot::create_directory"
      "--skip=extractors::common::Chroot::create_fifo"
      "--skip=extractors::common::Chroot::create_file"
      "--skip=extractors::common::Chroot::create_socket"
      "--skip=extractors::common::Chroot::create_symlink"
      "--skip=extractors::common::Chroot::make_executable"
    ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "-V";

  meta = {
    description = "Firmware Analysis Tool";
    homepage = "https://github.com/ReFirmLabs/binwalk";
    changelog = "https://github.com/ReFirmLabs/binwalk/releases/tag/v${version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      koral
      felbinger
    ];
    mainProgram = "binwalk";
  };
}
