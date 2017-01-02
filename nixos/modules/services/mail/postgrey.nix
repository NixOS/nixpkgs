{ config, lib, pkgs, ... }:

with lib; let

  cfg = config.services.postgrey;

  natural = with types; addCheck int (x: x >= 0);
  natural' = with types; addCheck int (x: x > 0);

  socket = with types; addCheck (either (submodule unixSocket) (submodule inetSocket)) (x: x ? "path" || x ? "port");

  inetSocket = with types; {
    addr = mkOption {
      type = nullOr string;
      default = null;
      example = "127.0.0.1";
      description = "The address to bind to. Localhost if null";
    };
    port = mkOption {
      type = natural';
      default = 10030;
      description = "Tcp port to bind to";
    };
  };

  unixSocket = with types; {
    path = mkOption {
      type = path;
      default = "/var/run/postgrey.sock";
      description = "Path of the unix socket";
    };

    mode = mkOption {
      type = string;
      default = "0777";
      description = "Mode of the unix socket";
    };
  };

in {

  options = {
    services.postgrey = with types; {
      enable = mkOption {
        type = bool;
        default = false;
        description = "Whether to run the Postgrey daemon";
      };
      socket = mkOption {
        type = socket;
        default = { path = "/var/run/postgrey.sock"; };
        example = {
          addr = "127.0.0.1";
          port = 10030;
        };
        description = "Socket to bind to";
      };
      greylistText = mkOption {
        type = string;
        default = "Greylisted for %%s seconds";
        description = "Response status text for greylisted messages; use %%s for seconds left until greylisting is over and %%r for mail domain of recipient";
      };
      greylistAction = mkOption {
        type = string;
        default = "DEFER_IF_PERMIT";
        description = "Response status for greylisted messages (see access(5))";
      };
      greylistHeader = mkOption {
        type = string;
        default = "X-Greylist: delayed %%t seconds by postgrey-%%v at %%h; %%d";
        description = "Prepend header to greylisted mails; use %%t for seconds delayed due to greylisting, %%v for the version of postgrey, %%d for the date, and %%h for the host";
      };
      delay = mkOption {
        type = natural;
        default = 300;
        description = "Greylist for N seconds";
      };
      maxAge = mkOption {
        type = natural;
        default = 35;
        description = "Delete entries from whitelist if they haven't been seen for N days";
      };
      retryWindow = mkOption {
        type = either string natural;
        default = 2;
        example = "12h";
        description = "Allow N days for the first retry. Use string with appended 'h' to specify time in hours";
      };
      lookupBySubnet = mkOption {
        type = bool;
        default = true;
        description = "Strip the last N bits from IP addresses, determined by IPv4CIDR and IPv6CIDR";
      };
      IPv4CIDR = mkOption {
        type = natural;
        default = 24;
        description = "Strip N bits from IPv4 addresses if lookupBySubnet is true";
      };
      IPv6CIDR = mkOption {
        type = natural;
        default = 64;
        description = "Strip N bits from IPv6 addresses if lookupBySubnet is true";
      };
      privacy = mkOption {
        type = bool;
        default = true;
        description = "Store data using one-way hash functions (SHA1)";
      };
      autoWhitelist = mkOption {
        type = nullOr natural';
        default = 5;
        description = "Whitelist clients after successful delivery of N messages";
      };
    };
  };

  config = mkIf cfg.enable {

    environment.systemPackages = [ pkgs.postgrey ];

    users = {
      extraUsers = {
        postgrey = {
          description = "Postgrey Daemon";
          uid = config.ids.uids.postgrey;
          group = "postgrey";
        };
      };
      extraGroups = {
        postgrey = {
          gid = config.ids.gids.postgrey;
        };
      };
    };

    systemd.services.postgrey = let
      bind-flag = if cfg.socket ? "path" then
        ''--unix=${cfg.socket.path} --socketmode=${cfg.socket.mode}''
      else
        ''--inet=${optionalString (cfg.socket.addr != null) (cfg.socket.addr + ":")}${cfg.socket.port}'';
    in {
      description = "Postfix Greylisting Service";
      wantedBy = [ "multi-user.target" ];
      before = [ "postfix.service" ];
      preStart = ''
        mkdir -p /var/postgrey
        chown postgrey:postgrey /var/postgrey
        chmod 0770 /var/postgrey
      '';
      serviceConfig = {
        Type = "simple";
        ExecStart = ''${pkgs.postgrey}/bin/postgrey ${bind-flag} --group=postgrey --user=postgrey --dbdir=/var/postgrey --delay=${cfg.delay} --max-age=${cfg.maxAge} --retry-window=${cfg.retryWindow} ${if cfg.lookupBySubnet then "--lookup-by-subnet" else "--lookup-by-host"} --ipv4cidr=${cfg.IPv4CIDR} --ipv6cidr=${cfg.IPv6CIDR} ${optionalString cfg.privacy "--privacy"} --auto-whitelist-clients=${if cfg.autoWhitelist == null then "0" else cfg.autoWhitelist} --greylist-text="${cfg.greylistText}" --x-greylist-header="${cfg.greylistHeader}" --greylist-action=${cfg.greylistAction}'';
        Restart = "always";
        RestartSec = 5;
        TimeoutSec = 10;
      };
    };

  };

}
