{
  lib,
  buildGoModule,
  fetchFromGitHub,
  hwinfo,
  libusb1,
  gcc,
  pkg-config,
  makeWrapper,
  nixosTests,
  stdenv,
  systemdMinimal,
}:
let
  # We are waiting on some changes to be merged upstream: https://github.com/openSUSE/hwinfo/pulls
  hwinfoOverride = hwinfo.overrideAttrs {
    src = fetchFromGitHub {
      owner = "numtide";
      repo = "hwinfo";
      rev = "bfeab0b4e38b200c7a62a44d4d01601a86fe1091";
      hash = "sha256-GL3fNCSaU45fNihEksgtPtbuLkc+tVGXtPH05wbrHwI=";
    };
  };
in
buildGoModule rec {
  pname = "nixos-facter";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "numtide";
    repo = "nixos-facter";
    tag = "v${version}";
    hash = "sha256-oMOiZhppyUwyhLMtTofmeQINi8rHwsuQ1cD8Kr1/KwM=";
  };

  vendorHash = "sha256-5duwAxAgbPZIbbgzZE2m574TF/0+jF/TvTKI4YBH6jM=";

  env.CGO_ENABLED = 1;

  buildInputs = [
    libusb1
    hwinfoOverride
  ];

  nativeBuildInputs = [
    gcc
    pkg-config
    makeWrapper
  ];

  # nixos-facter calls systemd-detect-virt
  postInstall = ''
    wrapProgram "$out/bin/nixos-facter" \
        --prefix PATH : "${lib.makeBinPath [ systemdMinimal ]}"
  '';

  ldflags = [
    "-s"
    "-w"
    "-X git.numtide.com/numtide/nixos-facter/build.Name=nixos-facter"
    "-X git.numtide.com/numtide/nixos-facter/build.Version=v${version}"
    "-X github.com/numtide/nixos-facter/pkg/build.System=${stdenv.hostPlatform.system}"
  ];

  passthru.tests = {
    inherit (nixosTests) facter;
  };

  meta = {
    description = "Declarative hardware configuration for NixOS";
    homepage = "https://github.com/numtide/nixos-facter";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.brianmcgee ];
    mainProgram = "nixos-facter";
    platforms = lib.platforms.linux;
  };
}
