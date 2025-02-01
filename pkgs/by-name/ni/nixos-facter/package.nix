{
  lib,
  buildGoModule,
  fetchFromGitHub,
  hwinfo,
  libusb1,
  gcc,
  pkg-config,
  util-linux,
  pciutils,
  stdenv,
}:
let
  # We are waiting on some changes to be merged upstream: https://github.com/openSUSE/hwinfo/pulls
  hwinfoOverride = hwinfo.overrideAttrs {
    src = fetchFromGitHub {
      owner = "numtide";
      repo = "hwinfo";
      rev = "42b014495b2de8735eeec950bc2d3afbefc65ec4";
      hash = "sha256-OXbGF8M1r8GSgqeY4TqfjF+IO0SXXB/dX2jE2JtkPUk=";
    };
  };
in
buildGoModule rec {
  pname = "nixos-facter";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "numtide";
    repo = "nixos-facter";
    rev = "v${version}";
    hash = "sha256-TBSzIaOuD/IEObgwSx0UwFFAkqF1pAAWhDrNDtQShdY=";
  };

  vendorHash = "sha256-8yQO7topYvXL6bP0oSVN1rApiPjse4Q2bjFNM5jVl8c=";

  CGO_ENABLED = 1;

  buildInputs = [
    libusb1
    hwinfoOverride
  ];

  nativeBuildInputs = [
    gcc
    pkg-config
  ];

  runtimeInputs = [
    libusb1
    util-linux
    pciutils
  ];

  ldflags = [
    "-s"
    "-w"
    "-X git.numtide.com/numtide/nixos-facter/build.Name=nixos-facter"
    "-X git.numtide.com/numtide/nixos-facter/build.Version=v${version}"
    "-X github.com/numtide/nixos-facter/pkg/build.System=${stdenv.hostPlatform.system}"
  ];

  meta = {
    description = "Declarative hardware configuration for NixOS";
    homepage = "https://github.com/numtide/nixos-facter";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.brianmcgee ];
    mainProgram = "nixos-facter";
    platforms = lib.platforms.linux;
  };
}
