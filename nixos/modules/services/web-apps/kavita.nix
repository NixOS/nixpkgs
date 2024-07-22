{ config, lib, pkgs, utils, ... }:

let
  cfg = config.services.kavita;
  settingsFormat = pkgs.formats.json { };
in
{
  imports = [
    (lib.mkChangedOptionModule [ "services" "kavita" "ipAdresses" ] [ "services" "kavita" "settings" "IpAddresses" ] (config:
      let value = lib.getAttrFromPath [ "services" "kavita" "ipAdresses" ] config; in
      lib.concatStringsSep "," value
    ))
    (lib.mkRenamedOptionModule [ "services" "kavita" "port" ] [ "services" "kavita" "settings" "Port" ])
  ];

  options.services.kavita = {
    enable = lib.mkEnableOption "Kavita reading server";

    user = lib.mkOption {
      type = lib.types.str;
      default = "kavita";
      description = "User account under which Kavita runs.";
    };

    package = lib.mkPackageOption pkgs "kavita" { };

    dataDir = lib.mkOption {
      default = "/var/lib/kavita";
      type = lib.types.str;
      description = "The directory where Kavita stores its state.";
    };

    tokenKeyFile = lib.mkOption {
      type = lib.types.path;
      description = ''
        A secret with at least 512 bits.
        It can be generated with `head -c 64 /dev/urandom | base64 --wrap=0`.
      '';
    };

    settings = lib.mkOption {
      default = { };
      description = ''
        Kavita configuration options, as configured in {file}`appsettings.json`.
      '';
      type = lib.types.submodule {
        freeformType = settingsFormat.type;

        options = {
          Port = lib.mkOption {
            default = 5000;
            type = lib.types.port;
            description = "Port to bind to.";
          };

          IpAddresses = lib.mkOption {
            default = "0.0.0.0,::";
            type = lib.types.commas;
            description = ''
              IP Addresses to bind to. The default is to bind to all IPv4 and IPv6 addresses.
            '';
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.kavita = {
      description = "Kavita";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      preStart = utils.genConfigOutOfBand {
        config = { TokenKey._secret = cfg.tokenKeyFile; } // cfg.settings;
        configLocation = "${lib.escapeShellArg cfg.dataDir}/config/appsettings.json";
        generator = utils.genConfigOutOfBandFormatAdapter settingsFormat;
      };
      serviceConfig = {
        WorkingDirectory = cfg.dataDir;
        ExecStart = lib.getExe cfg.package;
        Restart = "always";
        User = cfg.user;
      };
    };

    systemd.tmpfiles.rules = [
      "d '${cfg.dataDir}'        0750 ${cfg.user} ${cfg.user} - -"
      "d '${cfg.dataDir}/config' 0750 ${cfg.user} ${cfg.user} - -"
    ];

    users = {
      users.${cfg.user} = {
        description = "kavita service user";
        isSystemUser = true;
        group = cfg.user;
        home = cfg.dataDir;
      };
      groups.${cfg.user} = { };
    };
  };

  meta.maintainers = with lib.maintainers; [ misterio77 ];
}
