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
  squashfs-tools,
  stdenv,
  wimlib,
}:

let
  bins = [
    coreutils
    debootstrap
    gnupg
    gnutar
    squashfs-tools
  ]
  ++ lib.optionals stdenv.hostPlatform.isx86_64 [
    # repack-windows deps
    cdrkit
    hivex
    wimlib
  ];
in
buildGoModule (finalAttrs: {
  pname = "distrobuilder";
  version = "3.4.0";

  vendorHash = "sha256-ipKwCeUNVgtkQTPOB5lze2SFaktClUr+4+c0uLX5J/w=";

  src = fetchFromGitHub {
    owner = "lxc";
    repo = "distrobuilder";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dcRUUHpaqNCq4eld+anVrGKywJNpZLJYu3WtERlP3Ps=";
  };

  buildInputs = bins;

  # tests require a local keyserver (mkg20001/nixpkgs branch distrobuilder-with-tests) but gpg is currently broken in tests
  doCheck = false;

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ]
  ++ bins;

  # upstream only supports make targets due to GOFLAGS, but none of the targets work for us
  # this could be fragile, but the alternative is copying them here
  preBuild = ''
    export GOFLAGS="$(grep 'export GOFLAGS' Makefile | sed 's/export GOFLAGS=//') -trimpath"
  '';

  postInstall = ''
    wrapProgram $out/bin/distrobuilder --prefix PATH ":" ${lib.makeBinPath bins}
  '';

  passthru = {
    tests = {
      incus-lts = nixosTests.incus-lts.container;
    };

    generator = callPackage ./generator.nix { inherit (finalAttrs) src version; };

    updateScript = nix-update-script { };
  };

  meta = {
    description = "System container image builder for LXC and LXD";
    homepage = "https://github.com/lxc/distrobuilder";
    changelog = "https://github.com/lxc/distrobuilder/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    teams = [ lib.teams.lxc ];
    platforms = lib.platforms.linux;
    mainProgram = "distrobuilder";
  };
})
