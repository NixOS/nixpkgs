{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.stubby;
  settingsFormat = pkgs.formats.yaml { };
  confFile = settingsFormat.generate "stubby.yml" cfg.settings;
in {
  imports = map (x:
    (mkRemovedOptionModule [ "services" "stubby" x ]
      "Stubby configuration moved to services.stubby.settings.")) [
        "authenticationMode"
        "fallbackProtocols"
        "idleTimeout"
        "listenAddresses"
        "queryPaddingBlocksize"
        "roundRobinUpstreams"
        "subnetPrivate"
        "upstreamServers"
      ];

  options = {
    services.stubby = {

      enable = mkEnableOption "Stubby DNS resolver";

      settings = mkOption {
        type = types.attrsOf settingsFormat.type;
        example = lib.literalExpression ''
          pkgs.stubby.passthru.settingsExample // {
            upstream_recursive_servers = [{
              address_data = "158.64.1.29";
              tls_auth_name = "kaitain.restena.lu";
              tls_pubkey_pinset = [{
                digest = "sha256";
                value = "7ftvIkA+UeN/ktVkovd/7rPZ6mbkhVI7/8HnFJIiLa4=";
              }];
            }];
          };
        '';
        description = lib.mdDoc ''
          Content of the Stubby configuration file. All Stubby settings may be set or queried
          here. The default settings are available at
          `pkgs.stubby.passthru.settingsExample`. See
          <https://dnsprivacy.org/wiki/display/DP/Configuring+Stubby>.
          A list of the public recursive servers can be found here:
          <https://dnsprivacy.org/wiki/display/DP/DNS+Privacy+Test+Servers>.
        '';
      };

      debugLogging = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc "Enable or disable debug level logging.";
      };

    };
  };

  config = mkIf cfg.enable {
    assertions = [{
      assertion =
        (cfg.settings.resolution_type or "") == "GETDNS_RESOLUTION_STUB";
      message = ''
        services.stubby.settings.resolution_type must be set to "GETDNS_RESOLUTION_STUB".
        Is services.stubby.settings unset?
      '';
    }];

    services.stubby.settings.appdata_dir = "/var/cache/stubby";

    systemd.services.stubby = {
      description = "Stubby local DNS resolver";
      after = [ "network.target" ];
      before = [ "nss-lookup.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "notify";
        AmbientCapabilities = "CAP_NET_BIND_SERVICE";
        CapabilityBoundingSet = "CAP_NET_BIND_SERVICE";
        ExecStart = "${pkgs.stubby}/bin/stubby -C ${confFile} ${optionalString cfg.debugLogging "-l"}";
        DynamicUser = true;
        CacheDirectory = "stubby";
      };
    };
  };
}
