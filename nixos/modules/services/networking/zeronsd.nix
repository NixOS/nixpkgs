{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.zeronsd;
  settingsFormat = pkgs.formats.json { };
in
{
  options.services.zeronsd.servedNetworks = lib.mkOption {
    default = { };
    example = {
      "a8a2c3c10c1a68de".settings.token = "/var/lib/zeronsd/apitoken";
    };
    description = "ZeroTier Networks to start zeronsd instances for.";
    type = lib.types.attrsOf (
      lib.types.submodule {
        options = {
          package = lib.mkPackageOption pkgs "zeronsd" { };

          settings = lib.mkOption {
            description = "Settings for zeronsd";
            default = { };
            type = lib.types.submodule {
              freeformType = settingsFormat.type;

              options = {
                domain = lib.mkOption {
                  default = "home.arpa";
                  type = lib.types.singleLineStr;
                  description = "Domain under which ZeroTier records will be available.";
                };

                token = lib.mkOption {
                  type = lib.types.path;
                  description = "Path to a file containing the API Token for ZeroTier Central.";
                };

                log_level = lib.mkOption {
                  default = "warn";
                  type = lib.types.enum [
                    "off"
                    "error"
                    "warn"
                    "info"
                    "debug"
                    "trace"
                  ];
                  description = "Log Level.";
                };

                wildcard = lib.mkOption {
                  default = false;
                  type = lib.types.bool;
                  description = "Whether to serve a wildcard record for ZeroTier Nodes.";
                };
              };
            };
          };
        };
      }
    );
  };

  config = lib.mkIf (cfg.servedNetworks != { }) {
    assertions = [
      {
        assertion = config.services.zerotierone.enable;
        message = "zeronsd needs a configured zerotier-one";
      }
    ];

    systemd.services = lib.mapAttrs' (netname: netcfg: {
      name = "zeronsd-${netname}";
      value = {
        description = "ZeroTier DNS server for Network ${netname}";

        wantedBy = [ "multi-user.target" ];
        after = [
          "network.target"
          "zerotierone.service"
        ];
        wants = [ "network-online.target" ];

        serviceConfig =
          let
            configFile = pkgs.writeText "zeronsd.json" (builtins.toJSON netcfg.settings);
          in
          {
            ExecStart = "${netcfg.package}/bin/zeronsd start --config ${configFile} --config-type json ${netname}";
            Restart = "on-failure";
            RestartSec = 2;
            TimeoutStopSec = 5;
            User = "zeronsd";
            Group = "zeronsd";
            AmbientCapabilities = "CAP_NET_BIND_SERVICE";
          };
      };
    }) cfg.servedNetworks;

    systemd.tmpfiles.rules = [
      "a+ /var/lib/zerotier-one - - - - mask::x,u:zeronsd:x"
      "a+ /var/lib/zerotier-one/authtoken.secret - - - - mask::r,u:zeronsd:r"
    ];

    users.users.zeronsd = {
      group = "zeronsd";
      description = "Service user for running zeronsd";
      isSystemUser = true;
    };

    users.groups.zeronsd = { };
  };
}
