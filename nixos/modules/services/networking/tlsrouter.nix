{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.tlsrouter;
  configFile = pkgs.writeText "tlsrouter.conf" cfg.config;
in
{
  options.services.tlsrouter = {
    enable = lib.mkEnableOption "TLS SNI router";

    config = lib.mkOption {
      default = "";
      example = ''
        # Basic hostname -> backend mapping
        go.universe.tf localhost:1234

        # DNS wildcards are understood as well.
        *.go.universe.tf 1.2.3.4:8080

        # DNS wildcards can go anywhere in name.
        google.* 10.20.30.40:443

        # RE2 regexes are also available
        /(alpha|beta|gamma)\.mon(itoring)?\.dave\.tf/ 100.200.100.200:443

        # If your backend supports HAProxy's PROXY protocol, you can enable
        # it to receive the real client ip:port.

        fancy.backend 2.3.4.5:443 PROXY
      '';
      type = lib.types.lines;
      description = ''
        tlsrouter configfile to use.
      '';
    };

    listen = lib.mkOption {
      default = ":443";
      type = lib.types.str;
      description = "Set the listen address.";
    };

    helloTimeout = lib.mkOption {
      default = "3s";
      type = lib.types.str;
      description = "How long to wait for the start of the TLS handshake.";
    };

    package = lib.mkPackageOption pkgs "tlsrouter" { };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.tlsrouter = {
      description = "TLS SNI router";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        PermissionsStartOnly = true;
        LimitNPROC = 512;
        LimitNOFILE = 1048576;
        CapabilityBoundingSet = "cap_net_bind_service";
        AmbientCapabilities = "cap_net_bind_service";
        NoNewPrivileges = true;
        DynamicUser = true;
        ExecStart = "${lib.getBin cfg.package}/bin/tlsrouter -conf ${configFile} -listen ${cfg.listen} -hello-timeout ${cfg.helloTimeout}";
        Restart = "on-failure";
      };
    };
  };

  meta.maintainers = [ lib.maintainers.xsteadfastx ];
}
