{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    concatStringsSep
    getBin
    maintainers
    mapAttrsToList
    mkIf
    mkOption
    mkPackageOption
    optionalString
    types
    ;

  cfg = config.services.tlsrouter;

  configFile = pkgs.writeText "tlsrouter.conf" (
    concatStringsSep "\n" (
      mapAttrsToList (src: opts: "${src} ${opts.backend}${optionalString opts.proxy " PROXY"}") cfg.routes
    )
  );
in
{
  options.services.tlsrouter = {
    enable = lib.mkEnableOption "TLS SNI router";

    routes = mkOption {
      type = types.attrsOf (
        types.submodule {
          options.proxy = mkOption {
            type = types.bool;
            default = false;
            description = "If your backend supports HAProxy's PROXY protocol, you can enable it to receive the real client ip:port";
          };
          options.backend = mkOption {
            type = types.nonEmptyStr;
            description = "Backend address";
            example = "localhost:1234";
          };
        }
      );
      description = "TLSRouter requires a configuration that tells it what backend to use for a given hostname";
      example = {
        # Basic hostname -> backend mapping
        "go.universe.tf".backend = "localhost:1234";

        # DNS wildcards are understood as well
        "*.go.universe.tf".backend = "1.2.3.4:8080";

        # DNS wildcards can go anywhere in name
        "google.*".backend = "10.20.30.40:443";

        # RE2 regexes are also available
        "/(alpha|beta|gamma)\.mon(itoring)?\.dave\.tf/".backend = "100.200.100.200:443";

        # If your backend supports HAProxy's PROXY protocol, you can enable
        # it to receive the real client ip:port.
        "fancy.backend" = {
          backend = "2.3.4.5:443";
          proxy = true;
        };
      };
    };

    listen = mkOption {
      default = ":443";
      type = types.str;
      description = "Set the listen address.";
    };

    helloTimeout = mkOption {
      default = "3s";
      type = types.str;
      description = "How long to wait for the start of the TLS handshake.";
    };

    package = mkPackageOption pkgs "tlsrouter" { };
  };

  config = mkIf cfg.enable {
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
        ExecStart = "${getBin cfg.package}/bin/tlsrouter -conf ${configFile} -listen ${cfg.listen} -hello-timeout ${cfg.helloTimeout}";
        Restart = "on-failure";
      };
    };
  };

  meta.maintainers = [ maintainers.xsteadfastx ];
}
