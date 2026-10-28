# Non-module dependencies (`importApply`)
{ }:

# Service module
{
  lib,
  config,
  options,
  ...
}:
let
  inherit (lib)
    getExe
    mkOption
    types
    ;
  cfg = config.snid;
in
{
  # https://nixos.org/manual/nixos/unstable/#modular-services
  _class = "service";

  options = {
    snid = {
      package = mkOption {
        description = "Package to use for snid.";
        defaultText = "The snid package that provided this module.";
        type = types.package;
      };

      listen = mkOption {
        description = ''
          Addresses to listen on, in go-listener syntax.

          Examples: `"tcp:443"`, `"tcp:0.0.0.0:443"`, `"tcp:192.0.2.4:443"`.
        '';
        type = types.listOf types.str;
        example = [ "tcp:0.0.0.0:443" ];
      };

      mode = mkOption {
        description = ''
          Proxy mode. One of `nat46`, `tcp`, or `unix`.
        '';
        type = types.enum [
          "nat46"
          "tcp"
          "unix"
        ];
      };

      defaultHostname = mkOption {
        description = ''
          Hostname to use if a client does not include the SNI extension.
          If null, SNI-less connections will be terminated with a TLS alert.
        '';
        type = types.nullOr types.str;
        default = null;
      };

      nat46Prefix = mkOption {
        description = ''
          IPv6 prefix for the source address when connecting to the backend
          in NAT46 mode. The client's IPv4 address is placed in the lower 4
          bytes.

          Note: this prefix must be routed to the local host, e.g.
          ```
          ip route add local 64:ff9b:1::/96 dev lo
          ```
        '';
        type = types.nullOr types.str;
        default = null;
        example = "64:ff9b:1::";
      };

      backendCidrs = mkOption {
        description = ''
          Subnets to which connections may be forwarded. Connections to
          addresses outside these subnets are rejected. Used in `nat46` and
          `tcp` modes.
        '';
        type = types.listOf types.str;
        default = [ ];
        example = [
          "2001:db8::/64"
          "192.0.2.0/24"
        ];
      };

      backendPort = mkOption {
        description = ''
          Port number to connect to on the backend in TCP mode. If null,
          snid uses the same port as the inbound connection.
        '';
        type = types.nullOr types.port;
        default = null;
      };

      unixDirectory = mkOption {
        description = ''
          Path to the directory containing UNIX domain sockets, used in
          `unix` mode.
        '';
        type = types.nullOr types.path;
        default = null;
      };

      proxyProto = mkOption {
        description = ''
          Use PROXY protocol v2 to convey the client IP address to the
          backend. Applicable in `tcp` and `unix` modes.
        '';
        type = types.bool;
        default = false;
      };
    };
  };

  config = {
    assertions = [
      {
        assertion = cfg.mode == "nat46" -> cfg.nat46Prefix != null;
        message = "snid: `nat46Prefix` must be set when `mode` is `nat46`.";
      }
      {
        assertion = cfg.mode == "nat46" -> cfg.backendCidrs != [ ];
        message = "snid: `backendCidrs` must be set when `mode` is `nat46`.";
      }
      {
        assertion = cfg.mode == "tcp" -> cfg.backendCidrs != [ ];
        message = "snid: `backendCidrs` must be set when `mode` is `tcp`.";
      }
      {
        assertion = cfg.mode == "unix" -> cfg.unixDirectory != null;
        message = "snid: `unixDirectory` must be set when `mode` is `unix`.";
      }
    ];

    process.argv = [
      (getExe cfg.package)
    ];

    process.flagFormat = flag: {
      option = "-${flag}";
      explicitBool = false;
      sep = null;
    };

    process.flags = lib.mkMerge [
      {
        mode = cfg.mode;
        default-hostname = cfg.defaultHostname;
        nat46-prefix = cfg.nat46Prefix;
        backend-port = cfg.backendPort;
        unix-directory = cfg.unixDirectory;
        proxy-proto = cfg.proxyProto;
      }
      (map (v: { listen = v; }) cfg.listen)
      (map (v: { backend-cidr = v; }) cfg.backendCidrs)
    ];
  }
  // lib.optionalAttrs (options ? systemd) {
    systemd.service = {
      after = [ "network.target" ];
      wants = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Restart = "on-failure";
        DynamicUser = true;
        AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
      };
    };
  };
}
