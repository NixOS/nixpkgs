{ config, lib, pkgs, ... }:
let
  inherit (lib)
    mapAttrs'
    filterAttrs
    ;
in
{
  config = {
    environment.etc = mapAttrs' (_: { packages, name, ... }: {
      name = "profiles/per-user/${name}";
      value.source = pkgs.buildEnv {
        name = "user-environment";
        paths = packages;
        inherit (config.environment) pathsToLink extraOutputsToInstall;
        inherit (config.system.path) ignoreCollisions postBuild;
      };
    }) (filterAttrs (_: u: u.packages != []) config.users.users);

    environment.profiles = [
      "$HOME/.nix-profile"
      "/etc/profiles/per-user/$USER"
    ];
  };
}
