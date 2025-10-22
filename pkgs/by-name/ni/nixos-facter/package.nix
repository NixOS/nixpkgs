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
buildGoModule rec {
  pname = "nixos-facter";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "numtide";
    repo = "nixos-facter";
    tag = "v${version}";
    hash = "sha256-4kER7CyFvMKVpKxCYHuf9fkkYVzVK9AWpF55cBNzPc0=";
  };

  vendorHash = "sha256-A7ZuY8Gc/a0Y8O6UG2WHWxptHstJOxi4n9F8TY6zqiw=";

  env.CGO_ENABLED = 1;

  buildInputs = [
    libusb1
    hwinfo
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
