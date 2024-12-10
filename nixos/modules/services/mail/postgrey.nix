{ config, lib, pkgs, ... }:

with lib; let

  cfg = config.services.postgrey;

  natural = with types; addCheck int (x: x >= 0);
  natural' = with types; addCheck int (x: x > 0);

  socket = with types; addCheck (either (submodule unixSocket) (submodule inetSocket)) (x: x ? path || x ? port);

  inetSocket = with types; {
    options = {
      addr = mkOption {
        type = nullOr str;
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
  };

  unixSocket = with types; {
    options = {
      path = mkOption {
        type = path;
        default = "/run/postgrey.sock";
        description = "Path of the unix socket";
      };

      mode = mkOption {
        type = str;
        default = "0777";
        description = "Mode of the unix socket";
      };
    };
  };

in {
  imports = [
    (mkMergedOptionModule [ [ "services" "postgrey" "inetAddr" ] [ "services" "postgrey" "inetPort" ] ] [ "services" "postgrey" "socket" ] (config: let
        value = p: getAttrFromPath p config;
        inetAddr = [ "services" "postgrey" "inetAddr" ];
        inetPort = [ "services" "postgrey" "inetPort" ];
      in
        if value inetAddr == null
        then { path = "/run/postgrey.sock"; }
        else { addr = value inetAddr; port = value inetPort; }
    ))
  ];

  options = {
    services.postgrey = with types; {
      enable = mkOption {
        type = bool;
        default = false;
        description = "Whether to run the Postgrey daemon";
      };
      socket = mkOption {
        type = socket;
        default = {
          path = "/run/postgrey.sock";
          mode = "0777";
        };
        example = {
          addr = "127.0.0.1";
          port = 10030;
        };
        description = "Socket to bind to";
      };
      greylistText = mkOption {
        type = str;
        default = "Greylisted for %%s seconds";
        description = "Response status text for greylisted messages; use %%s for seconds left until greylisting is over and %%r for mail domain of recipient";
      };
      greylistAction = mkOption {
        type = str;
        default = "DEFER_IF_PERMIT";
        description = "Response status for greylisted messages (see access(5))";
      };
      greylistHeader = mkOption {
        type = str;
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
        type = either str natural;
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
      whitelistClients = mkOption {
        type = listOf path;
        default = [];
        description = "Client address whitelist files (see postgrey(8))";
      };
      whitelistRecipients = mkOption {
        type = listOf path;
        default = [];
        description = "Recipient address whitelist files (see postgrey(8))";
      };
    };
  };

  config = mkIf cfg.enable {

    environment.systemPackages = [ pkgs.postgrey ];

    users = {
      users = {
        postgrey = {
          description = "Postgrey Daemon";
          uid = config.ids.uids.postgrey;
          group = "postgrey";
        };
      };
      groups = {
        postgrey = {
          gid = config.ids.gids.postgrey;
        };
      };
    };

    systemd.services.postgrey = let
      bind-flag = if cfg.socket ? path then
        "--unix=${cfg.socket.path} --socketmode=${cfg.socket.mode}"
      else
        ''--inet=${optionalString (cfg.socket.addr != null) (cfg.socket.addr + ":")}${toString cfg.socket.port}'';
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
        ExecStart = ''${pkgs.postgrey}/bin/postgrey \
          ${bind-flag} \
          --group=postgrey --user=postgrey \
          --dbdir=/var/postgrey \
          --delay=${toString cfg.delay} \
          --max-age=${toString cfg.maxAge} \
          --retry-window=${toString cfg.retryWindow} \
          ${if cfg.lookupBySubnet then "--lookup-by-subnet" else "--lookup-by-host"} \
          --ipv4cidr=${toString cfg.IPv4CIDR} --ipv6cidr=${toString cfg.IPv6CIDR} \
          ${optionalString cfg.privacy "--privacy"} \
          --auto-whitelist-clients=${toString (if cfg.autoWhitelist == null then 0 else cfg.autoWhitelist)} \
          --greylist-action=${cfg.greylistAction} \
          --greylist-text="${cfg.greylistText}" \
          --x-greylist-header="${cfg.greylistHeader}" \
          ${concatMapStringsSep " " (x: "--whitelist-clients=" + x) cfg.whitelistClients} \
          ${concatMapStringsSep " " (x: "--whitelist-recipients=" + x) cfg.whitelistRecipients}
        '';
        Restart = "always";
        RestartSec = 5;
        TimeoutSec = 10;
      };
    };

  };

}
