{ lib, config, options, ... }:
let
  inherit (lib) mkOption types;
in
{
  options = {
    systemd.services = lib.mkOption {
      description = ''
        This module configures systemd services, with the notable difference that their unit names will be prefixed with the abstract service name.

        This option's value is not suitable for reading, but you can define a module here that interacts with just the unit configuration in the host system configuration.
      '';
      # ^ if we don't want to support this, we can add the systemd options that 
      # we care about here, and combine them into a host system definition
      # outside the control of this module - in services/abstract/systemd.nix.

      type = types.lazyAttrsOf (types.deferredModuleWith { staticModules = [
        # TODO Add the modules from systemd? They'll be deduplicated, but
        #      will generate docs in this part of the hierarchy. Is such duplication
        #      desirable? Perhaps!
      ]; });
    };
  };
  config = {
    # Empty string "" is ok, because it will be prefixed by the abstraction layer
    # anyway. Actual names here are for when multiple systemd services are needed.
    # I might have overengineered this for a demonstration :thinking_face:.
    #
    # Note that this is the systemd.services option above, not the system one.
    # This pattern allows a module to do all sorts of systemd stuff if it needs to.
    systemd.services."" = {
      description = "TBD add an option for that";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        Restart = "always";
        RestartSec = "5";
        ExecStart = [ (lib.escapeShellArgs ([ config.foreground.process ] ++ config.foreground.args)) ];
      };
    };
  };
}