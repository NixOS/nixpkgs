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

<<<<<<< HEAD
  meta.maintainers = with maintainers; [ veehaitch newam thomasjm ];
=======
  meta.maintainers = with maintainers; [ veehaitch newam ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}
