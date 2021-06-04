{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkOption types;
  inherit (pkgs) solanum;
  cfg = config.services.solanum;

  configFile = pkgs.writeText "solanum.conf" cfg.config;
in

{

  ###### interface

  options = {

    services.solanum = {

      enable = mkEnableOption "Solanum IRC daemon";

      config = mkOption {
        type = types.str;
        default = ''
          serverinfo {
            name = "irc.example.com";
            sid = "1ix";
            description = "irc!";

            vhost = "0.0.0.0";
            vhost6 = "::";
          };

          listen {
            host = "0.0.0.0";
            port = 6667;
          };

          auth {
            user = "*@*";
            class = "users";
            flags = exceed_limit;
          };
          channel {
            default_split_user_count = 0;
          };
        '';
        description = ''
          Solanum IRC daemon configuration file.
          check <link xlink:href="https://github.com/solanum-ircd/solanum/blob/main/doc/reference.conf"/> for all options.
        '';
      };

      openFilesLimit = mkOption {
        type = types.int;
        default = 1024;
        description = ''
          Maximum number of open files. Limits the clients and server connections.
        '';
      };

      motd = mkOption {
        type = types.nullOr types.lines;
        default = null;
        description = ''
          Solanum MOTD text.

          Solanum will read its MOTD from <literal>/etc/solanum/ircd.motd</literal>.
          If set, the value of this option will be written to this path.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable (lib.mkMerge [
    {
      systemd.services.solanum = {
        description = "Solanum IRC daemon";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          ExecStart   = "${solanum}/bin/solanum -foreground -logfile /dev/stdout -configfile ${configFile} -pidfile /run/solanum/ircd.pid";
          DynamicUser = true;
          User = "solanum";
          StateDirectory = "solanum";
          RuntimeDirectory = "solanum";
          LimitNOFILE = "${toString cfg.openFilesLimit}";
        };
      };

    }

    (mkIf (cfg.motd != null) {
      environment.etc."solanum/ircd.motd".text = cfg.motd;
    })
  ]);
}
