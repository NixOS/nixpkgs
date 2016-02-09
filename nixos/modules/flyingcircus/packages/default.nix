{ ... }:


{
  nixpkgs.config.packageOverrides = pkgs: rec {

    fcagent = pkgs.callPackage ./fcagent.nix { };
    nagiosplugin = pkgs.callPackage ./nagiosplugin.nix { };

    sensu = pkgs.callPackage ./sensu { };
    sensu_plugins = pkgs.callPackage ./sensu-plugins { };
    uchiwa = pkgs.callPackage ./uchiwa { };

  };
}
