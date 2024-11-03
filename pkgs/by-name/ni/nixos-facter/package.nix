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
      rev = "a559f34934098d54096ed2078e750a8245ae4044";
      hash = "sha256-3abkWPr98qXXQ17r1Z43gh2M5hl/DHjW2hfeWl+GSAs=";
    };
  };
in
buildGoModule rec {
  pname = "nixos-facter";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "numtide";
    repo = "nixos-facter";
    rev = "v${version}";
    hash = "sha256-vlPmvCrgX64dcf//BPtQszBt7dkq35JpgQg+/LW0AqM=";
  };

  vendorHash = "sha256-5leiTNp3FJmgFd0SKhu18hxYZ2G9SuQPhZJjki2SDVs=";

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
