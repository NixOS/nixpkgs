# This module generates nixos-install, nixos-rebuild,
# nixos-generate-config, etc.

{ config, lib, pkgs, modulesPath, ... }:

with lib;

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

  nixos-install = makeProg {
    name = "nixos-install";
    src = ./nixos-install.sh;
    nix = config.nix.package.out;
    path = makeBinPath [ nixos-enter ];
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
    inherit (config.system.nixos) release;
  };

  nixos-option = makeProg {
    name = "nixos-option";
    src = ./nixos-option.sh;
  };

  nixos-version = makeProg {
    name = "nixos-version";
    src = ./nixos-version.sh;
    inherit (config.system.nixos) version codeName revision;
  };

  nixos-enter = makeProg {
    name = "nixos-enter";
    src = ./nixos-enter.sh;
  };

in

{

  config = {

    environment.systemPackages =
      [ nixos-build-vms
        nixos-install
        nixos-rebuild
        nixos-generate-config
        nixos-option
        nixos-version
        nixos-enter
      ];

    system.build = {
      inherit nixos-install nixos-prepare-root nixos-generate-config nixos-option nixos-rebuild nixos-enter;
    };

  };

}
