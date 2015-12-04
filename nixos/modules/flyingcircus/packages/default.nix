{ ... }:


{
  nixpkgs.config.packageOverrides = pkgs: rec {

    fcagent = pkgs.callPackage ./fcagent.nix { };
    nagiosplugin = pkgs.callPackage ./nagiosplugin.nix { };
  };
}
