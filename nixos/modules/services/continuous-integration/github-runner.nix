{ config
, pkgs
, lib
, ...
}@args:

with lib;

let
  cfg = config.services.github-runner;
in

{
  options.services.github-runner = import ./github-runner/options.nix (args // { includeNameDefault = true; });

  config = mkIf cfg.enable {
    services.github-runners.${cfg.name} = cfg;
  };
}
