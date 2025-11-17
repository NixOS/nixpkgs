{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.tor.torsocks;
  optionalNullStr = b: v: lib.optionalString (b != null) v;

  configFile = server: ''
    TorAddress ${toString (lib.head (lib.splitString ":" server))}
    TorPort    ${toString (lib.tail (lib.splitString ":" server))}

    OnionAddrRange ${cfg.onionAddrRange}

    ${optionalNullStr cfg.socks5Username "SOCKS5Username ${cfg.socks5Username}"}
    ${optionalNullStr cfg.socks5Password "SOCKS5Password ${cfg.socks5Password}"}

    AllowInbound ${if cfg.allowInbound then "1" else "0"}
  '';

  wrapTorsocks =
    name: server:
    pkgs.writeTextFile {
      name = name;
      text = ''
        #!${pkgs.runtimeShell}
        TORSOCKS_CONF_FILE=${pkgs.writeText "torsocks.conf" (configFile server)} ${pkgs.torsocks}/bin/torsocks "$@"
      '';
      executable = true;
      destination = "/bin/${name}";
    };

in
{
  options = {
    services.tor.torsocks = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to build `/etc/tor/torsocks.conf`
          containing the specified global torsocks configuration.
        '';
      };

      server = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1:9050";
        example = "192.168.0.20:1234";
        description = ''
          IP/Port of the Tor SOCKS server. Currently, hostnames are
          NOT supported by torsocks.
        '';
      };

      fasterServer = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1:9063";
        example = "192.168.0.20:1234";
        description = ''
          IP/Port of the Tor SOCKS server for torsocks-faster wrapper suitable for HTTP.
          Currently, hostnames are NOT supported by torsocks.
        '';
      };

      onionAddrRange = lib.mkOption {
        type = lib.types.str;
        default = "127.42.42.0/24";
        description = ''
          Tor hidden sites do not have real IP addresses. This
          specifies what range of IP addresses will be handed to the
          application as "cookies" for .onion names.  Of course, you
          should pick a block of addresses which you aren't going to
          ever need to actually connect to. This is similar to the
          MapAddress feature of the main tor daemon.
        '';
      };

      socks5Username = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "bob";
        description = ''
          SOCKS5 username. The `TORSOCKS_USERNAME`
          environment variable overrides this option if it is set.
        '';
      };

      socks5Password = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "sekret";
        description = ''
          SOCKS5 password. The `TORSOCKS_PASSWORD`
          environment variable overrides this option if it is set.
        '';
      };

      allowInbound = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Set Torsocks to accept inbound connections. If set to
          `true`, listen() and accept() will be
          allowed to be used with non localhost address.
        '';
      };

    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.torsocks
      (wrapTorsocks "torsocks-faster" cfg.fasterServer)
    ];

    environment.etc."tor/torsocks.conf" = {
      source = pkgs.writeText "torsocks.conf" (configFile cfg.server);
    };
  };
}
