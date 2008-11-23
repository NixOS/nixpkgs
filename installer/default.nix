{pkgs, config, nix}:

let

  makeProg = args: pkgs.substituteAll (args // {
    dir = "bin";
    isExecutable = true;
  });


  nixosCheckout = (import ./nixos-checkout.nix) {
    inherit pkgs config makeProg;
  };


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

  nixosRebuild = let inherit (nixosCheckout) repos defaultRepo;
                 in makeProg {
    defaultNIXOS   = (defaultRepo repos.nixos  ).target;
    defaultNIXPKGS = (defaultRepo repos.nixpkgs).target;
    name = "nixos-rebuild";
    src = ./nixos-rebuild.sh;
  };

  nixosGenSeccureKeys = makeProg {
    name = "nixos-gen-seccure-keys";
    src = ./nixos-gen-seccure-keys.sh;
  };

  inherit (nixosCheckout) nixosCheckout;

  nixosHardwareScan = makeProg {
    name = "nixos-hardware-scan";
    src = ./nixos-hardware-scan.pl;
    inherit (pkgs) perl;
  };

}
