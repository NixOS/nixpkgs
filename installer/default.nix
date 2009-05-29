{pkgs, config}:

let

  nix = config.environment.nix;

  makeProg = args: pkgs.substituteAll (args // {
    dir = "bin";
    isExecutable = true;
  });

in

{

  nixosInstall = makeProg {
    name = "nixos-install";
    src = ./nixos-install.sh;

    inherit (pkgs) perl;
    inherit nix;
    nixpkgsURL = config.installer.nixpkgsURL;

    pathsFromGraph = "${pkgs.path}/build-support/kernel/paths-from-graph.pl";

    nixClosure = pkgs.runCommand "closure"
      {exportReferencesGraph = ["refs" nix];}
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

}
