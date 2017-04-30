# This module generates nixos-install, nixos-rebuild,
# nixos-generate-config, etc.

{ config, pkgs, modulesPath, ... }:

let
  cfg = config.installer;

  makeProg = args: pkgs.substituteAll (args // {
    dir = "bin";
    isExecutable = true;
  });

  nixos-build-vms = makeProg {
    name = "nixos-build-vms";
    src = ./nixos-build-vms/nixos-build-vms.sh;
  };

  nixos-prepare-root = makeProg {
    name = "nixos-prepare-root";
    src = ./nixos-prepare-root.sh;

    nix = pkgs.nixUnstable;
    inherit (pkgs) perl pathsFromGraph rsync utillinux coreutils;
  };

  nixos-install = makeProg {
    name = "nixos-install";
    src = ./nixos-install.sh;

    inherit (pkgs) perl pathsFromGraph rsync;
    nix = config.nix.package.out;
    cacert = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
    root_uid = config.ids.uids.root;
    nixbld_gid = config.ids.gids.nixbld;
    prepare_root = nixos-prepare-root;

    nixClosure = pkgs.runCommand "closure"
      { exportReferencesGraph = ["refs" config.nix.package.out]; }
      "cp refs $out";
  };

  nixos-rebuild =
    let fallback = import ./nix-fallback-paths.nix; in
    makeProg {
      name = "nixos-rebuild";
      src = ./nixos-rebuild.sh;
      nix = config.nix.package.out;
      nix_x86_64_linux = fallback.x86_64-linux;
      nix_i686_linux = fallback.i686-linux;
    };

  nixos-generate-config = makeProg {
    name = "nixos-generate-config";
    src = ./nixos-generate-config.pl;
    path = [ pkgs.btrfs-progs ];
    perl = "${pkgs.perl}/bin/perl -I${pkgs.perlPackages.FileSlurp}/lib/perl5/site_perl";
    inherit (config.system) nixosRelease;
  };

  nixos-option = makeProg {
    name = "nixos-option";
    src = ./nixos-option.sh;
  };

  nixos-version = makeProg {
    name = "nixos-version";
    src = ./nixos-version.sh;
    inherit (config.system) nixosVersion nixosCodeName nixosRevision;
  };

in

{

  config = {

    environment.systemPackages =
      [ nixos-build-vms
        nixos-prepare-root
        nixos-install
        nixos-rebuild
        nixos-generate-config
        nixos-option
        nixos-version
      ];

    system.build = {
      inherit nixos-install nixos-prepare-root nixos-generate-config nixos-option nixos-rebuild;
    };

  };

}
