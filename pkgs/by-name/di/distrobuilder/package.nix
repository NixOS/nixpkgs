{
  lib,
  buildGoModule,
  callPackage,
  cdrkit,
  coreutils,
  debootstrap,
  fetchFromGitHub,
  gnupg,
  gnutar,
  hivex,
  makeWrapper,
  nixosTests,
  pkg-config,
  squashfsTools,
  stdenv,
  wimlib,
}:

let
  bins =
    [
      coreutils
      debootstrap
      gnupg
      gnutar
      squashfsTools
    ]
    ++ lib.optionals stdenv.hostPlatform.isx86_64 [
      # repack-windows deps
      cdrkit
      hivex
      wimlib
    ];
in
buildGoModule rec {
  pname = "distrobuilder";
  version = "3.1";

  vendorHash = "sha256-3oHLvOdHbOdaL2FTo+a5HmayNi/i3zoAsU/du9h1N30=";

  src = fetchFromGitHub {
    owner = "lxc";
    repo = "distrobuilder";
    rev = "refs/tags/distrobuilder-${version}";
    sha256 = "sha256-cIzIoLQmg1kgI1QRAmFh/ca88PJBW2yIY92BKHKwTMk=";
    fetchSubmodules = false;
  };

  buildInputs = bins;

  # tests require a local keyserver (mkg20001/nixpkgs branch distrobuilder-with-tests) but gpg is currently broken in tests
  doCheck = false;

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ] ++ bins;

  postInstall = ''
    wrapProgram $out/bin/distrobuilder --prefix PATH ":" ${lib.makeBinPath bins}
  '';

  passthru = {
    tests = {
      incus-lts = nixosTests.incus-lts.container;
    };

    generator = callPackage ./generator.nix { inherit src version; };
  };

  meta = {
    description = "System container image builder for LXC and LXD";
    homepage = "https://github.com/lxc/distrobuilder";
    license = lib.licenses.asl20;
    maintainers = lib.teams.lxc.members;
    platforms = lib.platforms.linux;
    mainProgram = "distrobuilder";
  };
}
