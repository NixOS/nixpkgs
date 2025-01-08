{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.redlib;

  args = lib.concatStringsSep " " ([
    "--port ${toString cfg.port}"
    "--address ${cfg.address}"
  ]);

  boolToString' = b: if b then "on" else "off";
in
{
  imports = [
    (lib.mkRenamedOptionModule
      [
        "services"
        "libreddit"
      ]
      [
        "services"
        "redlib"
      ]
    )
  ];

  options = {
    services.redlib = {
      enable = lib.mkEnableOption "Private front-end for Reddit";

      package = lib.mkPackageOption pkgs "redlib" { };

      address = lib.mkOption {
        default = "0.0.0.0";
        example = "127.0.0.1";
        type = lib.types.str;
        description = "The address to listen on";
      };

      port = lib.mkOption {
        default = 8080;
        example = 8000;
        type = lib.types.port;
        description = "The port to listen on";
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Open ports in the firewall for the redlib web interface";
      };

      settings = lib.mkOption {
        type = lib.types.submodule {
          freeformType =
            with lib.types;
            attrsOf (
              nullOr (oneOf [
                bool
                int
                str
              ])
            );
          options = { };
        };
        default = { };
        description = ''
          See [GitHub](https://github.com/redlib-org/redlib/tree/main?tab=readme-ov-file#configuration) for available settings.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.packages = [ cfg.package ];
    systemd.services.redlib = {
      wantedBy = [ "default.target" ];
      environment = lib.mapAttrs (_: v: if lib.isBool v then boolToString' v else toString v) cfg.settings;
      serviceConfig =
        {
          ExecStart = [
            ""
            "${lib.getExe cfg.package} ${args}"
          ];
        }
        // (
          if (cfg.port < 1024) then
            {
              AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
              CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
            }
          else
            {
              # A private user cannot have process capabilities on the host's user
              # namespace and thus CAP_NET_BIND_SERVICE has no effect.
              PrivateUsers = true;
            }
        );
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };
  };

  meta = {
    maintainers = with lib.maintainers; [ Guanran928 ];
  };
}
