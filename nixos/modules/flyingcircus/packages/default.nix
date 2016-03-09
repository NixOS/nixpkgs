{ ... }:


{
  nixpkgs.config.packageOverrides = pkgs: rec {

    boost159 = pkgs.callPackage ./boost-1.59.nix { };

    fcagent = pkgs.callPackage ./fcagent.nix { };
    nagiosplugin = pkgs.callPackage ./nagiosplugin.nix { };

    percona = pkgs.callPackage ./percona.nix { boost = boost159; };

    sensu = pkgs.callPackage ./sensu { };
    sensu_plugins = pkgs.callPackage ./sensu-plugins { };
    uchiwa = pkgs.callPackage ./uchiwa { };

  };
}
