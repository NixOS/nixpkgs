# Non-module dependencies (`importApply`)
{ pkgs }:

# Service module
{
  config,
  lib,
  ...
}:
let
  cfg = config.services.opengist;
  settingsFormat = pkgs.formats.yaml { };
  settingsFile = settingsFormat.generate "opengist-settings" cfg.settings;

  inherit (lib)
    getExe
    mkIf
    mkOption
    mkPackageOption
    ;
  inherit (lib.types)
    nullOr
    path
    submodule
    ;
in
{
  _class = "service";
  options = {
    opengist = {
      package = mkPackageOption pkgs "opengist" { };

      environmentFile = mkOption {
        type = nullOr path;
        default = null;
        description = ''
          File to load as environment file.
          See https://github.com/thomiceli/opengist/blob/master/docs/configuration/cheat-sheet.md for variable names and description.
          Some options can be configured through both the config file (via this module) and the environment. Conflict between those two is undocumented.
        '';
      };

      settings = mkOption {
        type = submodule {
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

  config = mkIf cfg.enable {
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
