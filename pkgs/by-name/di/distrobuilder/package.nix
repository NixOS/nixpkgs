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
  nix-update-script,
  nixosTests,
  pkg-config,
  squashfsTools,
  stdenv,
  wimlib,
}:

let
  bins = [
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
  version = "3.2";

  vendorHash = "sha256-nlqapWxuSZlbt22F3Y9X1uXFxJHvEoUBZDl078x8ZnA=";

  src = fetchFromGitHub {
    owner = "lxc";
    repo = "distrobuilder";
    tag = "distrobuilder-${version}";
    sha256 = "sha256-aDCx2WGAKdTNf0uMzwxG0AUmbuuWBFPYzNyycKklYOY=";
  };

  buildInputs = bins;

  # tests require a local keyserver (mkg20001/nixpkgs branch distrobuilder-with-tests) but gpg is currently broken in tests
  doCheck = false;

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ]
  ++ bins;

  postInstall = ''
    wrapProgram $out/bin/distrobuilder --prefix PATH ":" ${lib.makeBinPath bins}
  '';

  passthru = {
    tests = {
      incus-lts = nixosTests.incus-lts.container;
    };

    generator = callPackage ./generator.nix { inherit src version; };

    updateScript = nix-update-script { };
  };

  meta = {
    description = "System container image builder for LXC and LXD";
    homepage = "https://github.com/lxc/distrobuilder";
    license = lib.licenses.asl20;
    teams = [ lib.teams.lxc ];
    platforms = lib.platforms.linux;
    mainProgram = "distrobuilder";
  };
}
