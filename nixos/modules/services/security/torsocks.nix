{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.tor.torsocks;
  optionalNullStr = b: v: optionalString (b != null) v;

  configFile = server: ''
    TorAddress ${toString (head (splitString ":" server))}
    TorPort    ${toString (tail (splitString ":" server))}

    OnionAddrRange ${cfg.onionAddrRange}

    ${optionalNullStr cfg.socks5Username
        "SOCKS5Username ${cfg.socks5Username}"}
    ${optionalNullStr cfg.socks5Password
        "SOCKS5Password ${cfg.socks5Password}"}

    AllowInbound ${if cfg.allowInbound then "1" else "0"}
  '';

  wrapTorsocks = name: server: pkgs.writeTextFile {
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
      enable = mkOption {
        type        = types.bool;
        default     = config.services.tor.enable && config.services.tor.client.enable;
        description = ''
          Whether to build <literal>/etc/tor/torsocks.conf</literal>
          containing the specified global torsocks configuration.
        '';
      };

      server = mkOption {
        type    = types.str;
        default = "127.0.0.1:9050";
        example = "192.168.0.20:1234";
        description = ''
          IP/Port of the Tor SOCKS server. Currently, hostnames are
          NOT supported by torsocks.
        '';
      };

      fasterServer = mkOption {
        type    = types.str;
        default = "127.0.0.1:9063";
        example = "192.168.0.20:1234";
        description = ''
          IP/Port of the Tor SOCKS server for torsocks-faster wrapper suitable for HTTP.
          Currently, hostnames are NOT supported by torsocks.
        '';
      };

      onionAddrRange = mkOption {
        type    = types.str;
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

      socks5Username = mkOption {
        type    = types.nullOr types.str;
        default = null;
        example = "bob";
        description = ''
          SOCKS5 username. The <literal>TORSOCKS_USERNAME</literal>
          environment variable overrides this option if it is set.
        '';
      };

      socks5Password = mkOption {
        type    = types.nullOr types.str;
        default = null;
        example = "sekret";
        description = ''
          SOCKS5 password. The <literal>TORSOCKS_PASSWORD</literal>
          environment variable overrides this option if it is set.
        '';
      };

      allowInbound = mkOption {
        type    = types.bool;
        default = false;
        description = ''
          Set Torsocks to accept inbound connections. If set to
          <literal>true</literal>, listen() and accept() will be
          allowed to be used with non localhost address.
        '';
      };

    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.torsocks (wrapTorsocks "torsocks-faster" cfg.fasterServer) ];

    environment.etc."tor/torsocks.conf" =
      {
        source = pkgs.writeText "torsocks.conf" (configFile cfg.server);
      };
  };
}
