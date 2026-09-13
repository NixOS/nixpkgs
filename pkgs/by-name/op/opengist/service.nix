# Non-module dependencies (`importApply`)
{ formats }:

# Service module
{
  config,
  lib,
  ...
}:
let
  cfg = config.opengist;
  settingsFormat = formats.yaml { };
  settingsFile = settingsFormat.generate "opengist-settings" cfg.settings;

  inherit (lib)
    getExe
    mkIf
    mkOption
    mkPackageOption
    types
    ;
in
{
  _class = "service";
  options = {
    opengist = {
      package = mkOption {
        description = "Package to use for opengist";
        defaultText = "The opengist package that provided this module.";
        type = types.package;
      };

      environmentFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = ''
          File to load as environment file.
          See https://github.com/thomiceli/opengist/blob/master/docs/configuration/cheat-sheet.md for variable names and description.
          Some options can be configured through both the config file (via this module) and the environment. Conflict between those two is undocumented.
        '';
      };

      settings = mkOption {
        type = types.submodule {
          freeformType = settingsFormat.type;
          options = {
          };
        };

        default = { };

        description = ''
          Configuration for Opengist.
          Supported options can be found in the [example config](https://github.com/thomiceli/opengist/blob/master/config.yml). [Most setings](https://github.com/thomiceli/opengist/blob/master/docs/configuration/cheat-sheet.md) can also be set from the environment file.
        '';
      };
    };
  };

  config = {
    systemd.services.opengist = {
      description = "Self-hosted pastebin powered by Git";
      after = [ "network-online.target" ];
      requires = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Restart = "on-failure";
        ExecStart = "${getExe cfg.package} -c ${settingsFile}";
        EnvironmentFile = lib.optional (cfg.environmentFile != null) cfg.environmentFile;
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ tomasrivera ];
}
