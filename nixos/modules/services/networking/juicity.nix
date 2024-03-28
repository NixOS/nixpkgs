{ pkgs
, config
, lib
, ...
}:
with lib;
let
  cfg = config.services.juicity;
in
{
  meta = {
    maintainers = with lib.maintainers; [ oluceps ];
  };

  options.services.juicity = {
    instances = mkOption {
      description = "list of juicity instance";
      type = types.listOf (types.submodule {
        options = {
          name = mkOption {
            type = types.str;
            description = "juicity instance name";
          };
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
          serve = mkEnableOption "Use `juicity-server` instead of `juicity-client` if set `true`";
          configFile = mkOption {
            type = types.str;
            default = "/etc/juicity/server.json";
            description = "Config file location, absolute path";
          };
        };
      });
      default = [ ];
    };
  };

  config =
    mkIf (cfg.instances != [ ])
      {
        environment.systemPackages = lib.unique (lib.foldr
          (s: acc: acc ++ [ s.package ]) [ ]
          cfg.instances);


        networking.firewall.allowedUDPPorts =
          lib.foldr
            (s: acc: acc ++
              (lib.optional (s.openFirewall != null) s.openFirewall)) [ ]
            cfg.instances;

        systemd.services = lib.foldr
          (s: acc: acc // {
            "juicity-${s.name}" = {
              wantedBy = [ "multi-user.target" ];
              after = [ "network.target" "nss-lookup.target" ];
              description = "juicity daemon";
              serviceConfig =
                let binSuffix = if s.serve then "server" else "client"; in {
                  Type = "simple";
                  DynamicUser = true;
                  ExecStart = "${s.package}/bin/juicity-${binSuffix} run -c $\{CREDENTIALS_DIRECTORY}/config";
                  LoadCredential = [ "config:${s.configFile}" ] ++ s.credentials;
                  AmbientCapabilities = [ "CAP_NET_ADMIN" "CAP_NET_BIND_SERVICE" "CAP_NET_RAW" ];
                  CapabilityBoundingSet = [ "CAP_NET_ADMIN" "CAP_NET_BIND_SERVICE" "CAP_NET_RAW" ];
                  LimitNPROC = 512;
                  LimitNOFILE = "infinity";
                  Restart = "on-failure";
                };
            };
          })
          { }
          cfg.instances;
      };
}
