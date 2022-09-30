{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.spacecookie;

  spacecookieConfig = {
    listen = {
      inherit (cfg) port;
    };
  } // cfg.settings;

  format = pkgs.formats.json {};

  configFile = format.generate "spacecookie.json" spacecookieConfig;

in {
  imports = [
    (mkRenamedOptionModule [ "services" "spacecookie" "root" ] [ "services" "spacecookie" "settings" "root" ])
    (mkRenamedOptionModule [ "services" "spacecookie" "hostname" ] [ "services" "spacecookie" "settings" "hostname" ])
  ];

  options = {

    services.spacecookie = {

      enable = mkEnableOption (lib.mdDoc "spacecookie");

      package = mkOption {
        type = types.package;
        default = pkgs.spacecookie;
        defaultText = literalExpression "pkgs.spacecookie";
        example = literalExpression "pkgs.haskellPackages.spacecookie";
        description = lib.mdDoc ''
          The spacecookie derivation to use. This can be used to
          override the used package or to use another version.
        '';
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to open the necessary port in the firewall for spacecookie.
        '';
      };

      port = mkOption {
        type = types.port;
        default = 70;
        description = lib.mdDoc ''
          Port the gopher service should be exposed on.
        '';
      };

      address = mkOption {
        type = types.str;
        default = "[::]";
        description = lib.mdDoc ''
          Address to listen on. Must be in the
          `ListenStream=` syntax of
          [systemd.socket(5)](https://www.freedesktop.org/software/systemd/man/systemd.socket.html).
        '';
      };

      settings = mkOption {
        type = types.submodule {
          freeformType = format.type;

          options.hostname = mkOption {
            type = types.str;
            default = "localhost";
            description = lib.mdDoc ''
              The hostname the service is reachable via. Clients
              will use this hostname for further requests after
              loading the initial gopher menu.
            '';
          };

          options.root = mkOption {
            type = types.path;
            default = "/srv/gopher";
            description = lib.mdDoc ''
              The directory spacecookie should serve via gopher.
              Files in there need to be world-readable since
              the spacecookie service file sets
              `DynamicUser=true`.
            '';
          };

          options.log = {
            enable = mkEnableOption (lib.mdDoc "logging for spacecookie")
              // { default = true; example = false; };

            hide-ips = mkOption {
              type = types.bool;
              default = true;
              description = lib.mdDoc ''
                If enabled, spacecookie will hide personal
                information of users like IP addresses from
                log output.
              '';
            };

            hide-time = mkOption {
              type = types.bool;
              # since we are starting with systemd anyways
              # we deviate from the default behavior here:
              # journald will add timestamps, so no need
              # to double up.
              default = true;
              description = lib.mdDoc ''
                If enabled, spacecookie will not print timestamps
                at the beginning of every log line.
              '';
            };

            level = mkOption {
              type = types.enum [
                "info"
                "warn"
                "error"
              ];
              default = "info";
              description = lib.mdDoc ''
                Log level for the spacecookie service.
              '';
            };
          };
        };

        description = lib.mdDoc ''
          Settings for spacecookie. The settings set here are
          directly translated to the spacecookie JSON config
          file. See
          [spacecookie.json(5)](https://sternenseemann.github.io/spacecookie/spacecookie.json.5.html)
          for explanations of all options.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = !(cfg.settings ? user);
        message = ''
          spacecookie is started as a normal user, so the setuid
          feature doesn't work. If you want to run spacecookie as
          a specific user, set:
          systemd.services.spacecookie.serviceConfig = {
            DynamicUser = false;
            User = "youruser";
            Group = "yourgroup";
          }
        '';
      }
      {
        assertion = !(cfg.settings ? listen || cfg.settings ? port);
        message = ''
          The NixOS spacecookie module uses socket activation,
          so the listen options have no effect. Use the port
          and address options in services.spacecookie instead.
        '';
      }
    ];

    systemd.sockets.spacecookie = {
      description = "Socket for the Spacecookie Gopher Server";
      wantedBy = [ "sockets.target" ];
      listenStreams = [ "${cfg.address}:${toString cfg.port}" ];
      socketConfig = {
        BindIPv6Only = "both";
      };
    };

    systemd.services.spacecookie = {
      description = "Spacecookie Gopher Server";
      wantedBy = [ "multi-user.target" ];
      requires = [ "spacecookie.socket" ];

      serviceConfig = {
        Type = "notify";
        ExecStart = "${lib.getBin cfg.package}/bin/spacecookie ${configFile}";
        FileDescriptorStoreMax = 1;

        DynamicUser = true;

        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        PrivateDevices = true;
        PrivateMounts = true;
        PrivateUsers = true;

        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;

        CapabilityBoundingSet = "";
        NoNewPrivileges = true;
        LockPersonality = true;
        RestrictRealtime = true;

        # AF_UNIX for communication with systemd
        # AF_INET replaced by BindIPv6Only=both
        RestrictAddressFamilies = "AF_UNIX AF_INET6";
      };
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };
  };
}
