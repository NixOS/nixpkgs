{
  config,
  lib,
  pkgs,
  ...
}:

let
  common-name = "sillytavern";
  cfg = config.services.sillytavern;
in
{
  meta.maintainers = [ lib.maintainers.wrvsrx ];
  options = {
    services.sillytavern = {
      enable = lib.mkEnableOption common-name;

      user = lib.mkOption {
        type = lib.types.str;
        default = common-name;
        description = ''
          User account under which the web-application run.
        '';
      };
      group = lib.mkOption {
        type = lib.types.str;
        default = common-name;
        description = ''
          Group account under which the web-application run.
        '';
      };

      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.sillytavern;
        defaultText = "pkgs.sillytavern";
        description = ''
          Sillytavern package to use.
        '';
      };

      configFile = lib.mkOption {
        type = lib.types.path;
        default = "${pkgs.sillytavern}/opt/sillytavern/config.yaml";
        defaultText = lib.literalExpression "\${pkgs.sillytavern}/opt/sillytavern/config.yaml";
        description = ''
          Path to the SillyTavern configuration file.
        '';
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 8045;
        description = ''
          Port on which SillyTavern will listen.
        '';
      };

      listenAddressIPv4 = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          Specific IPv4 address to listen to.
        '';
      };

      listenAddressIPv6 = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          Specific IPv6 address to listen to.
        '';
      };

      listen = lib.mkOption {
        type = lib.types.nullOr lib.types.bool;
        default = null;
        description = ''
          Whether to listen on all network interfaces.
        '';
      };

      whitelist = lib.mkOption {
        type = lib.types.nullOr lib.types.bool;
        default = null;
        description = ''
          Enables whitelist mode.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.sillytavern = {
      description = "Silly Tavern";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart =
          let
            f = x: name: if x != null then [ "--${name}=${builtins.toString x}" ] else [ ];
          in
          lib.concatStringsSep " " (
            [
              "${pkgs.sillytavern}/bin/sillytavern"
              "--dataRoot=%S/sillytavern/data"
              "--configPath=${cfg.configFile}"
              "--port=${builtins.toString cfg.port}"
            ]
            ++ f cfg.listen "listen"
            ++ f cfg.listenAddressIPv4 "listenAddressIPv4"
            ++ f cfg.listenAddressIPv6 "listenAddressIPv6"
            ++ f cfg.whitelist "whitelist"
          );
        User = cfg.user;
        Group = cfg.group;
        Restart = "always";
        StateDirectory = common-name;
      };
    };

    users.users.${cfg.user} = lib.mkIf (cfg.user == common-name) {
      description = "sillytavern service user";
      isSystemUser = true;
      inherit (cfg) group;
    };

    users.groups.${cfg.group} = lib.mkIf (cfg.group == common-name) { };

    systemd.tmpfiles.settings."${common-name}"."/var/lib/${common-name}/data".d.mode = "0700";
  };
}
