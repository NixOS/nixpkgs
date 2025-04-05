{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.ynetd;

  instanceOpts =
    { name, config, ... }:
    {
      options = {
        enable = mkEnableOption "ynetd instance ${name}";

        bindAddress = mkOption {
          type = types.nonEmptyStr;
          default = "::";
          description = "IP address to bind to";
        };

        port = mkOption {
          type = types.port;
          description = "TCP port to bind to";
        };

        user = mkOption {
          type = types.nonEmptyStr;
          default = "nobody";
          description = "Username to run the service as";
        };

        workingDir = mkOption {
          type = types.nullOr types.path;
          default = "";
          description = "Working directory for the command";
        };

        command = mkOption {
          type = types.nonEmptyStr;
          description = "Command to execute for each connection";
        };

        extraFlags = mkOption {
          type = types.str;
          default = "";
          description = "Additional flags to pass to ynetd";
        };
      };
    };

  # Generate systemd service for an instance
  mkService = name: instanceCfg: {
    description = "ynetd service for ${name}";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      ExecStart = ''
        ${cfg.package}/bin/ynetd \
          -a ${instanceCfg.bindAddress} \
          -p ${toString instanceCfg.port} \
          -u ${instanceCfg.user} \
          ${optionalString (instanceCfg.workingDir != "") "-d ${instanceCfg.workingDir}"} \
          ${instanceCfg.extraFlags} \
          "${instanceCfg.command}"
      '';
      User = "root";
      Restart = "always";
      RestartSec = "5s";
    };
  };
in
{
  options.services.ynetd = {
    enable = mkEnableOption "ynetd service";

    package = mkOption {
      type = types.package;
      default = pkgs.ynetd;
      defaultText = literalExpression "pkgs.ynetd";
      description = "The ynetd package to use (can be overridden with pkgs.ynetd.hardened for hardened version)";
    };

    instances = mkOption {
      type = types.attrsOf (types.submodule instanceOpts);
      default = { };
      description = "Attribute set of ynetd instances";
    };
  };

  config = mkIf cfg.enable {
    # Create systemd services for each enabled instance
    systemd.services = mapAttrs' (
      name: instanceCfg: nameValuePair "ynetd-${name}" (mkService name instanceCfg)
    ) (filterAttrs (_: instanceCfg: instanceCfg.enable) cfg.instances);

    environment.systemPackages = [ cfg.package ];
  };
}
