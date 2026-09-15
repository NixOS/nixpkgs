{
  config,
  lib,
  utils,
  ...
}:

let
  cfg = config.systemd.nspawn;
  inherit (utils.systemdUtils.unitOptions) unitOption;

  instanceOptions = {
    imports = [
      (lib.mkRenamedOptionModule [ "execConfig" ] [ "settings" "Exec" ])
      (lib.mkRenamedOptionModule [ "filesConfig" ] [ "settings" "Files" ])
      (lib.mkRenamedOptionModule [ "networkConfig" ] [ "settings" "Network" ])
    ];

    options = {
      enable = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = "If set to false, this instance's configuration file will not be generated.";
      };

      settings = lib.mkOption {
        default = { };
        description = ''
          Settings for this nspawn instance, organized by section.
          See {manpage}`systemd.nspawn(5)` for available options.
        '';
        type = lib.types.submodule {
          options.Exec = lib.mkOption {
            default = { };
            example = {
              Parameters = "/bin/sh";
            };
            type = lib.types.attrsOf unitOption;
            description = ''
              Options for the `[Exec]` section.
              See {manpage}`systemd.nspawn(5)` for details.
            '';
          };

          options.Files = lib.mkOption {
            default = { };
            example = {
              Bind = [ "/home/alice" ];
            };
            type = lib.types.attrsOf unitOption;
            description = ''
              Options for the `[Files]` section.
              See {manpage}`systemd.nspawn(5)` for details.
            '';
          };

          options.Network = lib.mkOption {
            default = { };
            example = {
              Private = false;
            };
            type = lib.types.attrsOf unitOption;
            description = ''
              Options for the `[Network]` section.
              See {manpage}`systemd.nspawn(5)` for details.
            '';
          };
        };
      };
    };
  };

in
{

  options = {

    systemd.nspawn = lib.mkOption {
      default = { };
      type = lib.types.attrsOf (lib.types.submodule instanceOptions);
      description = "Definition of systemd-nspawn configurations.";
    };

  };

  config =
    let
      enabledInstances = lib.filterAttrs (_: v: v.enable) cfg;
    in
    lib.mkMerge [
      (lib.mkIf (enabledInstances != { }) {
        environment.etc = lib.mapAttrs' (name: value: {
          name = "systemd/nspawn/${name}.nspawn";
          value.text = utils.systemdUtils.lib.settingsToSections value.settings;
        }) enabledInstances;
      })
      {
        systemd.targets.multi-user.wants = [ "machines.target" ];
        systemd.services."systemd-nspawn@".environment = {
          SYSTEMD_NSPAWN_UNIFIED_HIERARCHY = lib.mkDefault "1";
        };
      }
    ];
}
