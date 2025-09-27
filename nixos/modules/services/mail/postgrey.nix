{
  config,
  lib,
  pkgs,
  ...
}:
let

  cfg = config.services.postgrey;

  inherit (lib) types;

  socket = types.addCheck (types.either (types.submodule unixSocket) (types.submodule inetSocket)) (
    x: x ? path || x ? port
  );

  inetSocket = {
    options = {
      addr = lib.mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "127.0.0.1";
        description = "The address to bind to. Localhost if null";
      };
      port = lib.mkOption {
        type = types.port;
        default = 10030;
        description = "Tcp port to bind to";
      };
    };
  };

  unixSocket = {
    options = {
      path = lib.mkOption {
        type = types.path;
        default = "/run/postgrey.sock";
        description = "Path of the unix socket";
      };

      mode = lib.mkOption {
        type = types.str;
        default = "0777";
        description = "Mode of the unix socket";
      };
    };
  };

in
{
  imports = [
    (lib.mkMergedOptionModule
      [
        [
          "services"
          "postgrey"
          "inetAddr"
        ]
        [
          "services"
          "postgrey"
          "inetPort"
        ]
      ]
      [ "services" "postgrey" "socket" ]
      (
        config:
        let
          value = p: lib.getAttrFromPath p config;
          inetAddr = [
            "services"
            "postgrey"
            "inetAddr"
          ];
          inetPort = [
            "services"
            "postgrey"
            "inetPort"
          ];
        in
        if value inetAddr == null then
          { path = "/run/postgrey.sock"; }
        else
          {
            addr = value inetAddr;
            port = value inetPort;
          }
      )
    )
  ];

  options = {
    services.postgrey = {
      enable = lib.mkOption {
        type = types.bool;
        default = false;
        description = "Whether to run the Postgrey daemon";
      };
      socket = lib.mkOption {
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
      greylistText = lib.mkOption {
        type = types.str;
        default = "Greylisted for %%s seconds";
        description = "Response status text for greylisted messages; use %%s for seconds left until greylisting is over and %%r for mail domain of recipient";
      };
      greylistAction = lib.mkOption {
        type = types.str;
        default = "DEFER_IF_PERMIT";
        description = "Response status for greylisted messages (see {manpage}`access(5)`)";
      };
      greylistHeader = lib.mkOption {
        type = types.str;
        default = "X-Greylist: delayed %%t seconds by postgrey-%%v at %%h; %%d";
        description = "Prepend header to greylisted mails; use %%t for seconds delayed due to greylisting, %%v for the version of postgrey, %%d for the date, and %%h for the host";
      };
      delay = lib.mkOption {
        type = types.ints.unsigned;
        default = 300;
        description = "Greylist for N seconds";
      };
      maxAge = lib.mkOption {
        type = types.ints.unsigned;
        default = 35;
        description = "Delete entries from whitelist if they haven't been seen for N days";
      };
      retryWindow = lib.mkOption {
        type = types.either types.str types.ints.unsigned;
        default = 2;
        example = "12h";
        description = "Allow N days for the first retry. Use string with appended 'h' to specify time in hours";
      };
      lookupBySubnet = lib.mkOption {
        type = types.bool;
        default = true;
        description = "Strip the last N bits from IP addresses, determined by IPv4CIDR and IPv6CIDR";
      };
      IPv4CIDR = lib.mkOption {
        type = types.ints.unsigned;
        default = 24;
        description = "Strip N bits from IPv4 addresses if lookupBySubnet is true";
      };
      IPv6CIDR = lib.mkOption {
        type = types.ints.unsigned;
        default = 64;
        description = "Strip N bits from IPv6 addresses if lookupBySubnet is true";
      };
      privacy = lib.mkOption {
        type = types.bool;
        default = true;
        description = "Store data using one-way hash functions (SHA1)";
      };
      autoWhitelist = lib.mkOption {
        type = types.nullOr types.ints.positive;
        default = 5;
        description = "Whitelist clients after successful delivery of N messages";
      };
      whitelistClients = lib.mkOption {
        type = types.listOf types.path;
        default = [ ];
        description = "Client address whitelist files (see {manpage}`postgrey(8)`)";
      };
      whitelistRecipients = lib.mkOption {
        type = types.listOf types.path;
        default = [ ];
        description = "Recipient address whitelist files (see {manpage}`postgrey(8)`)";
      };
    };
  };

  config = lib.mkIf cfg.enable {

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

    systemd.services.postgrey =
      let
        bind-flag =
          if cfg.socket ? path then
            "--unix=${cfg.socket.path} --socketmode=${cfg.socket.mode}"
          else
            ''--inet=${
              lib.optionalString (cfg.socket.addr != null) (cfg.socket.addr + ":")
            }${toString cfg.socket.port}'';
      in
      {
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
          ExecStart = ''
            ${pkgs.postgrey}/bin/postgrey \
                      ${bind-flag} \
                      --group=postgrey --user=postgrey \
                      --dbdir=/var/postgrey \
                      --delay=${toString cfg.delay} \
                      --max-age=${toString cfg.maxAge} \
                      --retry-window=${toString cfg.retryWindow} \
                      ${if cfg.lookupBySubnet then "--lookup-by-subnet" else "--lookup-by-host"} \
                      --ipv4cidr=${toString cfg.IPv4CIDR} --ipv6cidr=${toString cfg.IPv6CIDR} \
                      ${lib.optionalString cfg.privacy "--privacy"} \
                      --auto-whitelist-clients=${
                        toString (if cfg.autoWhitelist == null then 0 else cfg.autoWhitelist)
                      } \
                      --greylist-action=${cfg.greylistAction} \
                      --greylist-text="${cfg.greylistText}" \
                      --x-greylist-header="${cfg.greylistHeader}" \
                      ${lib.concatMapStringsSep " " (x: "--whitelist-clients=" + x) cfg.whitelistClients} \
                      ${lib.concatMapStringsSep " " (x: "--whitelist-recipients=" + x) cfg.whitelistRecipients}
          '';
          Restart = "always";
          RestartSec = 5;
          TimeoutSec = 10;
        };
      };

  };

}
