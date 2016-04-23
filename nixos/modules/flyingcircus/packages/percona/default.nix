{ ... }:

{

  nixpkgs.config.packageOverrides = pkgs: rec {

    percona = pkgs.callPackage ./percona.nix { boost = pkgs.boost159; };
    xtrabackup = pkgs.callPackage ./xtrabackup.nix { };
    qpress = pkgs.callPackage ./qpress.nix { };

  };

}
