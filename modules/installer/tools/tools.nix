# This module generates nixos-install, nixos-rebuild,
# nixos-hardware-scan, etc.

{config, pkgs, ...}:

let
  ### implementation

  makeProg = args: pkgs.substituteAll (args // {
    dir = "bin";
    isExecutable = true;
  });
  
  nixosInstall = makeProg {
    name = "nixos-install";
    src = ./nixos-install.sh;

    inherit (pkgs) perl pathsFromGraph;
    nix = config.environment.nix;
    nixpkgsURL = config.installer.nixpkgsURL;

    nixClosure = pkgs.runCommand "closure"
      {exportReferencesGraph = ["refs" config.environment.nix];}
      "cp refs $out";
  };

  # rewrite of nixosInstall: each tool does exactly one job.
  # So they get more useful.
  installer2 =
  let nixClosure = pkgs.runCommand "closure"
        {exportReferencesGraph = ["refs" config.environment.nix];}
        "cp refs $out";

      nix = config.environment.nix;
  in rec {

    nixosPrepareInstall = makeProg {
      name = "nixos-prepare-install";
      src = ./installer2/nixos-prepare-install.sh;

      inherit nix nixClosure nixosBootstrap;
    };

    runInChroot = makeProg {
     name = "run-in-chroot";
       src = ./installer2/run-in-chroot.sh;
    };

    nixosBootstrap = makeProg {
      name = "nixos-bootstrap";
      src = ./installer2/nixos-bootstrap.sh;

      inherit (pkgs) coreutils;
      inherit nixClosure nix;

      # TODO shell ?
      nixpkgsURL = config.installer.nixpkgsURL;
    };

    # see ./nixos-bootstrap-archive/README-BOOTSTRAP-NIXOS
    # TODO refactor: It should *not* depend on configuration.nix
    # maybe even move this in nixpkgs?
    minimalInstallArchive = import ./nixos-bootstrap-archive {
      inherit (pkgs) stdenv runCommand perl pathsFromGraph gnutar coreutils bzip2;
      inherit nixosPrepareInstall runInChroot nixosBootstrap nixClosure;
    };
  };

  nixosRebuild = makeProg {
    name = "nixos-rebuild";
    src = ./nixos-rebuild.sh;
  };

  nixosGenSeccureKeys = makeProg {
    name = "nixos-gen-seccure-keys";
    src = ./nixos-gen-seccure-keys.sh;
  };

  nixosHardwareScan = makeProg {
    name = "nixos-hardware-scan";
    src = ./nixos-hardware-scan.pl;
    inherit (pkgs) perl;
  };

  nixosOption = makeProg {
    name = "nixos-option";
    src = ./nixos-option.sh;
  };

in

{
  options = {
  
    installer.nixpkgsURL = pkgs.lib.mkOption {
      default = "";
      example = http://nixos.org/releases/nix/nixpkgs-0.11pre7577;
      description = ''
        URL of the Nixpkgs distribution to use when building the
        installation CD.
      '';
    };

    installer.manifests = pkgs.lib.mkOption {
      default = [http://nixos.org/releases/nixpkgs/channels/nixpkgs-unstable/MANIFEST];
      example =
        [ http://nixos.org/releases/nixpkgs/channels/nixpkgs-unstable/MANIFEST
          http://nixos.org/releases/nixpkgs/channels/nixpkgs-stable/MANIFEST
        ];
      description = ''
        URLs of manifests to be downloaded when you run
        <command>nixos-rebuild</command> to speed up builds.
      '';
    };
    
  };

  config = {
    environment.systemPackages =
      [ nixosInstall
        nixosRebuild
         nixosHardwareScan
         nixosGenSeccureKeys
         nixosOption

         installer2.runInChroot
         installer2.nixosPrepareInstall
      ];

    system.build = {
      inherit nixosInstall;

      # expose scripts
      inherit (installer2) nixosPrepareInstall runInChroot nixosBootstrap minimalInstallArchive;
    };
  };
}
