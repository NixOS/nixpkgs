{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.mighttpd2;
  configFile = pkgs.writeText "mighty-config" cfg.config;
  routingFile = pkgs.writeText "mighty-routing" cfg.routing;
in
{
  options.services.mighttpd2 = {
    enable = mkEnableOption "Mighttpd2 web server";

    config = mkOption {
      default = "";
      example = ''
        # Example configuration for Mighttpd 2
        Port: 80
        # IP address or "*"
        Host: *
        Debug_Mode: Yes # Yes or No
        # If available, "nobody" is much more secure for User:.
        User: root
        # If available, "nobody" is much more secure for Group:.
        Group: root
        Pid_File: /run/mighty.pid
        Logging: Yes # Yes or No
        Log_File: /var/log/mighty # The directory must be writable by User:
        Log_File_Size: 16777216 # bytes
        Log_Backup_Number: 10
        Index_File: index.html
        Index_Cgi: index.cgi
        Status_File_Dir: /usr/local/share/mighty/status
        Connection_Timeout: 30 # seconds
        Fd_Cache_Duration: 10 # seconds
        # Server_Name: Mighttpd/3.x.y
        Tls_Port: 443
        Tls_Cert_File: cert.pem # should change this with an absolute path
        # should change this with comma-separated absolute paths
        Tls_Chain_Files: chain.pem
        # Currently, Tls_Key_File must not be encrypted.
        Tls_Key_File: privkey.pem # should change this with an absolute path
        Service: 0 # 0 is HTTP only, 1 is HTTPS only, 2 is both
      '';
      type = types.lines;
      description = ''
        Verbatim config file to use
        (see https://kazu-yamamoto.github.io/mighttpd2/config.html)
      '';
    };

    routing = mkOption {
      default = "";
      example = ''
        # Example routing for Mighttpd 2

        # Domain lists
        [localhost www.example.com]

        # Entries are looked up in the specified order
        # All paths must end with "/"

        # A path to CGI scripts should be specified with "=>"
        /~alice/cgi-bin/ => /home/alice/public_html/cgi-bin/

        # A path to static files should be specified with "->"
        /~alice/         -> /home/alice/public_html/
        /cgi-bin/        => /export/cgi-bin/

        # Reverse proxy rules should be specified with ">>"
        # /path >> host:port/path2
        # Either "host" or ":port" can be committed, but not both.
        /app/cal/        >> example.net/calendar/
        # Yesod app in the same server
        /app/wiki/       >> 127.0.0.1:3000/

        /                -> /export/www/
      '';
      type = types.lines;
      description = ''
        Verbatim routing file to use
        (see https://kazu-yamamoto.github.io/mighttpd2/config.html)
      '';
    };

    cores = mkOption {
      default = null;
      type = types.nullOr types.int;
      description = ''
        How many cores to use.
        If null it will be determined automatically
      '';
    };

  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.routing != "";
        message = "You need at least one rule in mighttpd2.routing";
      }
    ];
    systemd.services.mighttpd2 = {
      description = "Mighttpd2 web server";
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = ''
          ${pkgs.haskellPackages.mighttpd2}/bin/mighty \
            ${configFile} \
            ${routingFile} \
            +RTS -N${optionalString (cfg.cores != null) "${cfg.cores}"}
        '';
        Type = "simple";
        User = "mighttpd2";
        Group = "mighttpd2";
        Restart = "on-failure";
        AmbientCapabilities = "cap_net_bind_service";
        CapabilityBoundingSet = "cap_net_bind_service";
      };
    };

    users.users.mighttpd2 = {
      group = "mighttpd2";
      uid = config.ids.uids.mighttpd2;
      isSystemUser = true;
    };

    users.groups.mighttpd2.gid = config.ids.gids.mighttpd2;
  };

  meta.maintainers = with lib.maintainers; [ fgaz ];
}
