{ config, lib, pkgs, ... }:

let
  cfg = config.security.bubblewrap;
in {
  options.security.bubblewrap = {
    allowSetuid = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = lib.mdDoc ''
        Whether to set up a setuid wrapper for bubblewrap, a sandboxing solution.

        This is primarily useful for running packages using `buildFHSEnv` without user remapping,
        which allows other setuid executables to work inside the sandbox.
      '';
    };

    package = lib.mkPackageOptionMD pkgs "bubblewrap" {};
  };

  config = lib.mkIf cfg.allowSetuid {
    security.wrappers.bwrap = {
      setuid = true;
      owner = "root";
      group = "root";
      source = "${cfg.package}/bin/bwrap";
    };
  };
}
