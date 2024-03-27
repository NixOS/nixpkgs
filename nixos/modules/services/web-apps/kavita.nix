{ config, lib, pkgs, ... }:

let
  cfg = config.services.kavita;
  settingsFormat = pkgs.formats.json { };
  appsettings = settingsFormat.generate "appsettings.json" ({ TokenKey = "@TOKEN@"; } // cfg.settings);
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
    enable = lib.mkEnableOption (lib.mdDoc "Kavita reading server");

    user = lib.mkOption {
      type = lib.types.str;
      default = "kavita";
      description = lib.mdDoc "User account under which Kavita runs.";
    };

    package = lib.mkPackageOption pkgs "kavita" { };

    dataDir = lib.mkOption {
      default = "/var/lib/kavita";
      type = lib.types.str;
      description = lib.mdDoc "The directory where Kavita stores its state.";
    };

    tokenKeyFile = lib.mkOption {
      type = lib.types.path;
      description = lib.mdDoc ''
        A file containing the TokenKey, a secret with at 128+ bits.
        It can be generated with `head -c 32 /dev/urandom | base64`.
      '';
    };

    settings = lib.mkOption {
      default = { };
      description = lib.mdDoc ''
        Kavita configuration options, as configured in {file}`appsettings.json`.
      '';
      type = lib.types.submodule {
        freeformType = settingsFormat.type;

        options = {
          Port = lib.mkOption {
            default = 5000;
            type = lib.types.port;
            description = lib.mdDoc "Port to bind to.";
          };

          IpAddresses = lib.mkOption {
            default = "0.0.0.0,::";
            type = lib.types.commas;
            description = lib.mdDoc ''
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
      preStart = ''
        install -m600 ${appsettings} ${lib.escapeShellArg cfg.dataDir}/config/appsettings.json
        ${pkgs.replace-secret}/bin/replace-secret '@TOKEN@' \
          ''${CREDENTIALS_DIRECTORY}/token \
          '${cfg.dataDir}/config/appsettings.json'
      '';
      serviceConfig = {
        WorkingDirectory = cfg.dataDir;
        LoadCredential = [ "token:${cfg.tokenKeyFile}" ];
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
