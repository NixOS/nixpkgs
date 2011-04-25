# This module generates nixos-install, nixos-rebuild,
# nixos-hardware-scan, etc.

{config, pkgs, modulesPath, ...}:

let
  ### implementation
  cfg = config.installer;

  makeProg = args: pkgs.substituteAll (args // {
    dir = "bin";
    isExecutable = true;
  });

  nixosBuildVMS = makeProg {
    name = "nixos-build-vms";
    src = ./nixos-build-vms/nixos-build-vms.sh;
  };

  nixosDeployNetwork = makeProg {
    name = "nixos-deploy-network";
    src = ./nixos-deploy-network/nixos-deploy-network.sh;
  };

  nixosInstall = makeProg {
    name = "nixos-install";
    src = ./nixos-install.sh;

    inherit (pkgs) perl pathsFromGraph;
    nix = config.environment.nix;
    nixpkgsURL = cfg.nixpkgsURL;

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
      nixpkgsURL = cfg.nixpkgsURL;
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
    profile = cfg.installProfile;
  };

  nixosOption = makeProg {
    name = "nixos-option";
    src = ./nixos-option.sh;
  };

  nixosGui = pkgs.xulrunnerWrapper {
    launcher = "nixos-gui";
    application = pkgs.stdenv.mkDerivation {
      name = "nixos-gui";
      buildCommand = ''
        ensureDir $out
        cp -r $source $out
        cp $jquery $out/chrome/content/jquery-1.5.2.js
      '';
      sources = pkgs.lib.cleanSource "${modulesPath}/../gui";
      jquery = pkgs.fetchurl {
        url = http://code.jquery.com/jquery-1.5.2.min.js;
        sha256 = "e2107c8ecdb479c36d822d82bda2a8caf4429ab2d2cf9f20d5c931f75275403c";
      };
    };
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

    installer.installProfile = pkgs.lib.mkOption {
      default = "base";
      example = "graphical";
      description = ''
        Name of the profile used when generating the hardware-scan.
      '';
    };

    installer.enableGraphicalTools = pkgs.lib.mkOption {
      default = false;
      type = with pkgs.lib.types; bool;
      example = true;
      description = ''
        Enable the installation of graphical tools.
      '';
    };

  };

  config = {
    environment.systemPackages =
      [ nixosBuildVMS
        nixosDeployNetwork
        nixosInstall
        nixosRebuild
         nixosHardwareScan
         nixosGenSeccureKeys
         nixosOption

         installer2.runInChroot
         installer2.nixosPrepareInstall
      ] ++ pkgs.lib.optional cfg.enableGraphicalTools nixosGui;

    system.build = {
      inherit nixosInstall nixosHardwareScan nixosOption;

      # expose scripts
      inherit (installer2) nixosPrepareInstall runInChroot nixosBootstrap minimalInstallArchive;
    };
  };
}
