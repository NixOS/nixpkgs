{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkOption
    types
    mkPackageOption
    nameValuePair
    mkEnableOption
    mapAttrs'
    optional
    mkIf
    ;
  cfg = config.services.juicity;
in
{
  meta = {
    maintainers = with lib.maintainers; [ oluceps ];
  };

  options.services.juicity = {
    instances = mkOption {
      description = "list of juicity instance";
      type = types.attrsOf (
        types.submodule {
          options = {
            enable = mkEnableOption "enable this juicity instance";
            package = mkPackageOption pkgs "juicity" { };
            credentials = mkOption {
              type = types.listOf types.str;
              default = [ ];
              description = ''
                Load extra credentials.
                Could be written as systemd `LoadCredentials` format e.g.
                `["key:/etc/juicity-key"]` and access in config with
                `/run/credentials/juicity-$\{name}.service/key`
              '';
            };
            openFirewall = mkOption {
              type = with types; nullOr port;
              default = null;
              description = "Open firewall port";
            };
            serve = mkEnableOption "using `juicity-server` instead of `juicity-client`";
            configFile = mkOption {
              type = types.str;
              default = "/etc/juicity/server.json";
              description = "Config file location, absolute path";
            };
          };
        }
      );
      default = { };
    };
  };

  config = mkIf (cfg.instances != { }) {
    environment.systemPackages = lib.concatMap (s: optional s.enable s.package) (
      builtins.attrValues cfg.instances
    );

    # only allow udp port since juicity based on udp
    networking.firewall.allowedUDPPorts = lib.concatMap (
      s: lib.optional (s.enable && (s.openFirewall != null)) s.openFirewall
    ) (builtins.attrValues cfg.instances);

    systemd.services = mapAttrs' (
      name: opts:
      nameValuePair "juicity-${name}" {
        wantedBy = [ "multi-user.target" ];
        after = [
          "network.target"
          "nss-lookup.target"
        ];
        description = "juicity daemon";
        serviceConfig =
          let
            binSuffix = if opts.serve then "server" else "client";
          in
          {
            Type = "simple";
            DynamicUser = true;
            ExecStart = "${opts.package}/bin/juicity-${binSuffix} run -c $\{CREDENTIALS_DIRECTORY}/config";
            LoadCredential = [ "config:${opts.configFile}" ] ++ opts.credentials;
            AmbientCapabilities = [
              "CAP_NET_ADMIN"
              "CAP_NET_BIND_SERVICE"
              "CAP_NET_RAW"
            ];
            CapabilityBoundingSet = [
              "CAP_NET_ADMIN"
              "CAP_NET_BIND_SERVICE"
              "CAP_NET_RAW"
            ];
            LimitNPROC = 512;
            LimitNOFILE = "infinity";
            Restart = "on-failure";
          };
      }
    ) (lib.filterAttrs (_: v: v.enable) cfg.instances);
  };
}
