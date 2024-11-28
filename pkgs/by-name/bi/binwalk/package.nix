{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  fontconfig,
  bzip2,
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
  checkFlags = [
    "--skip=binwalk::Binwalk"
    "--skip=binwalk::Binwalk::analyze"
    "--skip=binwalk::Binwalk::extract"
    "--skip=binwalk::Binwalk::scan"
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
