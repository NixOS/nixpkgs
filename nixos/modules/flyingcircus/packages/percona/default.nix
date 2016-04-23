{ ... }:

{

  nixpkgs.config.packageOverrides = pkgs: rec {

    percona = pkgs.callPackage ./percona.nix { boost = (pkgs.callPackage ../boost-1.59.nix {}); };
    xtrabackup = pkgs.callPackage ./xtrabackup.nix { };
    qpress = pkgs.callPackage ./qpress.nix { };

  };

}
