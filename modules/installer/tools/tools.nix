# This module generates nixos-install, nixos-rebuild,
# nixos-hardware-scan, etc.

{config, pkgs, ...}:

let

  ### interface

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

in

{
  require = options;

  environment.systemPackages =
    [ nixosInstall
      nixosRebuild
      nixosHardwareScan
      nixosGenSeccureKeys
    ];
}
