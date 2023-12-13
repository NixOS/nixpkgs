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
  options.services.github-runner = import ./github-runner/options.nix (args // {
    # Users don't need to specify options.services.github-runner.name; it will default
    # to the hostname.
    includeNameDefault = true;
  });

  config = mkIf cfg.enable {
    services.github-runners.${cfg.name} = cfg;
  };

  meta.maintainers = with maintainers; [ veehaitch newam thomasjm ];
}
