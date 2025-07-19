{
  lib,
  config,
  systemdPackage,
  ...
}:
let
  inherit (lib) mkOption types;
in
{
  imports = [
    ../portable/service.nix
    (lib.mkAliasOptionModule [ "systemd" "service" ] [ "systemd" "services" "" ])
    (lib.mkAliasOptionModule [ "systemd" "socket" ] [ "systemd" "sockets" "" ])
  ];
  options = {
    systemd.services = mkOption {
      description = ''
        This module configures systemd services, with the notable difference that their unit names will be prefixed with the abstract service name.

        This option's value is not suitable for reading, but you can define a module here that interacts with just the unit configuration in the host system configuration.

        Note that this option contains _deferred_ modules.
        This means that the module has not been combined with the system configuration yet, no values can be read from this option.
        What you can do instead is define a module that reads from the module arguments (such as `config`) that are available when the module is merged into the system configuration.
      '';
      type = types.lazyAttrsOf (
        types.deferredModuleWith {
          staticModules = [
            # TODO: Add modules for the purpose of generating documentation?
          ];
        }
      );
      default = { };
    };
    systemd.sockets = mkOption {
      description = ''
        Declares systemd socket units. Names will be prefixed by the service name / path.

        See {option}`systemd.services`.
      '';
      type = types.lazyAttrsOf types.deferredModule;
      default = { };
    };

    # Also import systemd logic into sub-services
    # extends the portable `services` option
    services = mkOption {
      type = types.attrsOf (
        types.submoduleWith {
          class = "service";
          modules = [
            ./service.nix
          ];
          specialArgs = {
            inherit systemdPackage;
          };
        }
      );
    };
  };
  config = {
    # Note that this is the systemd.services option above, not the system one.
    systemd.services."" = {
      # TODO description;
      wantedBy = lib.mkDefault [ "multi-user.target" ];
      serviceConfig = {
        Type = lib.mkDefault "simple";
        Restart = lib.mkDefault "always";
        RestartSec = lib.mkDefault "5";
        ExecStart = [
          (systemdPackage.functions.escapeSystemdExecArgs config.process.argv)
        ];
      };
    };
  };
}
