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
  systemdMinimal,
}:
let
  # We are waiting on some changes to be merged upstream: https://github.com/openSUSE/hwinfo/pulls
  hwinfoOverride = hwinfo.overrideAttrs {
    src = fetchFromGitHub {
      owner = "numtide";
      repo = "hwinfo";
      rev = "c2259845d10694c099fb306a8cfc5a403e71c708";
      hash = "sha256-RGIoJkYiNMRHwUclzdRMELxCgBU9Pfvaghvt3op0zM0=";
    };
  };
in
buildGoModule rec {
  pname = "nixos-facter";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "numtide";
    repo = "nixos-facter";
    rev = "v${version}";
    hash = "sha256-T7x9xU/Tr2BKfrHQHrP6Mm6rNUWYASjEPzHIKgyS7aE=";
  };

  vendorHash = "sha256-qDzd+aq08PN9kl1YkvNLGvWaFVh7xFXJhGdx/ELwYGY=";

  env.CGO_ENABLED = 1;

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
    systemdMinimal
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
