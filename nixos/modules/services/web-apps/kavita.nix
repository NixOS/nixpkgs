{ config, lib, pkgs, ... }:

let
  cfg = config.services.kavita;
in {
  options.services.kavita = {
    enable = lib.mkEnableOption (lib.mdDoc "Kavita reading server");

    user = lib.mkOption {
      type = lib.types.str;
      default = "kavita";
      description = lib.mdDoc "User account under which Kavita runs.";
    };

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.kavita;
      defaultText = "pkgs.kavita";
      description = lib.mdDoc "Kavita package to use.";
    };

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
    port = lib.mkOption {
      default = 5000;
      type = lib.types.port;
      description = lib.mdDoc "Port to bind to.";
    };
    ipAdresses = lib.mkOption {
      default = ["0.0.0.0" "::"];
      type = lib.types.listOf lib.types.str;
      description = lib.mdDoc "IP Adresses to bind to. The default is to bind to all IPv4
      and IPv6 addresses.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.kavita = {
      description = "Kavita";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      preStart = ''
        mkdir -p "${cfg.dataDir}/config"
        cat > "${cfg.dataDir}/config/appsettings.json" <<EOF
        {
          "TokenKey": "$(cat ${cfg.tokenKeyFile})",
          "Port": ${toString cfg.port},
          "IpAddresses": "${lib.concatStringsSep "," cfg.ipAdresses}"
        }
        EOF
        chmod 640 ${cfg.dataDir}/config/appsettings.json
      '';
      serviceConfig = {
        WorkingDirectory = cfg.dataDir;
        ExecStart = "${lib.getExe cfg.package}";
        Restart = "always";
        User = cfg.user;
      };
    };

    users = {
      users.${cfg.user} = {
        description = "kavita service user";
        isSystemUser = true;
        group = cfg.user;
        home = cfg.dataDir;
        createHome = true;
      };
      groups.${cfg.user} = { };
    };
  };

  meta.maintainers = with lib.maintainers; [ misterio77 ];
}
