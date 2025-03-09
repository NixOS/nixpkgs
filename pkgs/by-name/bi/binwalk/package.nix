{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  fontconfig,
  bzip2,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "binwalk";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "ReFirmLabs";
    repo = "binwalk";
    rev = "refs/tags/v${version}";
    hash = "sha256-em+jOnhCZH5EEJrhXTHmxiwpMcBr5oNU1+5IJ1H/oco=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    fontconfig
    bzip2
  ];

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

  meta = {
    description = "Firmware Analysis Tool";
    homepage = "https://github.com/ReFirmLabs/binwalk";
    changelog = "https://github.com/ReFirmLabs/binwalk/releases/tag/${src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      koral
      felbinger
    ];
  };
}
