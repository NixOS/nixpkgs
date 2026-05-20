# Non-module dependencies (`importApply`)
{ }:

# Service module
{
  lib,
  config,
  options,
  ...
}:
let
  inherit (lib)
    getExe
    mkOption
    types
    ;
  cfg = config.backrest;
in
{
  # https://nixos.org/manual/nixos/unstable/#modular-services
  _class = "service";

  options = {
    backrest = {
      package = mkOption {
        description = "Package to use for backrest.";
        defaultText = "The backrest package that provided this module.";
        type = types.package;
      };

      address = mkOption {
        description = "Address to listen on.";
        type = types.str;
        default = "127.0.0.1";
      };

      port = mkOption {
        description = "Port to listen on.";
        type = types.port;
        default = 9898;
      };

      dataDir = mkOption {
        description = "Directory for internal data.";
        type = types.str;
        default = "/var/lib/backrest";
      };

      configPath = mkOption {
        description = "Path to config.json.";
        type = types.nullOr types.str;
        default = null;
      };

      extraArgs = mkOption {
        description = "Extra arguments to pass to backrest.";
        type = types.listOf types.str;
        default = [ ];
      };
    };
  };

  config = {
    process.argv = [
      (getExe cfg.package)
      "-bind-address"
      "${cfg.address}:${toString cfg.port}"
      "-data-dir"
      cfg.dataDir
    ]
    ++ lib.optionals (cfg.configPath != null) [
      "-config-file"
      cfg.configPath
    ]
    ++ cfg.extraArgs;
  }
  // lib.optionalAttrs (options ? systemd) {
    systemd.service = {
      after = [ "network.target" ];
      wants = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Restart = "always";
        DynamicUser = true;
        StateDirectory = "backrest";
        Environment = "HOME=${cfg.dataDir}";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ phanirithvij ];
}
