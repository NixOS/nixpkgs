{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.oidentd;
in
{
  meta.maintainers = [ lib.maintainers.h7x4 ];

  options.services.oidentd = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
      description = ''
        Whether to enable `oidentd`, an implementation of the Ident
        protocol (RFC 1413). It allows remote systems to identify the
        name of the user associated with a TCP connection.
      '';
    };

    package = lib.mkPackageOption pkgs "oidentd" { };

    grantHomeDirectoryAccess = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
      description = ''
        Whether to allow the daemon to read user's home directories.
        This is useful if you want to support user config specified in
        {file}`~/config/oidentd.conf`
      '';
    };

    listenStreams = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ "113" ];
      description = ''
        Which addresses to listen on.

        See {manpage}`systemd.socket(5)` for more information about the format.

        :::{.warning}
          If you change this to a different port, the {option}`openFirewall` option will not follow along.

          Please set {option}`networking.firewall.allowedTCPPorts` accordingly.
        :::
      '';
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
      description = ''
        Whether to open port `113` in the firewall.
      '';
    };

    settings =
      let
        capabilityDirectivesType =
          let
            mkCapabilityToggle =
              name:
              lib.mkOption {
                type = lib.types.nullOr lib.types.bool;
                description = "Whether to allow the user to use the `${name}` capability.";
                default = null;
                example = true;
              };
          in
          lib.types.submodule {
            options = {
              forward = mkCapabilityToggle "forward";
              hide = mkCapabilityToggle "hide";
              numeric = mkCapabilityToggle "numeric";
              random = mkCapabilityToggle "random";
              random_numeric = mkCapabilityToggle "random_numeric";
              spoof = mkCapabilityToggle "spoof";
              spoof_all = mkCapabilityToggle "spoof_all";
              spoof_privport = mkCapabilityToggle "spoof_privport";

              force = lib.mkOption {
                type = capabilityStatementsType;
                default = { };
                description = "Directives specified here forces the user to use the specified capability.";
              };
            };
          };

        capabilityStatementsType = lib.types.submodule {
          options = {
            forward = lib.mkOption {
              type = lib.types.nullOr (
                lib.types.submodule {
                  options = {
                    host = lib.mkOption {
                      type = lib.types.str;
                      description = "The FQDN of the target Ident server.";
                    };
                    port = lib.mkOption {
                      type = lib.types.port;
                      description = "The port of the target Ident server.";
                    };
                  };
                }
              );
              default = null;
              description = ''
                Forward received queries to another Ident server.

                The target server must support forwarding.
              '';
            };
            hide = lib.mkEnableOption "" // {
              description = ''
                If forwarding fails, oidentd responds with a "HIDDEN-USER" error.

                If set in {option}`settings.users`, the service might answer with
                the real username depending on whether the user has been granted
                the hide capability from the global configuration.
              '';
            };
            numeric = lib.mkEnableOption "" // {
              description = "Respond with the user ID (UID).";
            };
            random = lib.mkEnableOption "" // {
              description = ''
                Send randomly generated, alphanumeric Ident replies.

                A new reply is generated for each Ident lookup.
              '';
            };
            random_numeric = lib.mkEnableOption "" // {
              description = ''
                Send randomly generated, numeric Ident replies between 0 (inclusive) and 100,000 (exclusive), prefixed with "user"

                A new reply is generated for each Ident lookup.
              '';
            };
            reply = lib.mkOption {
              type = with lib.types; nullOr (nonEmptyListOf str);
              default = null;
              description = ''
                Send an Ident reply chosen at random from the given list of quoted replies.

                When used in a user configuration file, at most 20 replies may be specified. In the system-wide configuration file, up to 255 replies may be specified.
              '';
            };
          };
        };

        rangeDirectivesType = lib.types.submodule {
          freeformType = lib.types.attrsOf capabilityDirectivesType;
          options = {
            default = lib.mkOption {
              type = capabilityDirectivesType;
              description = "Default configuration without any range specified";
            };
          };
        };
      in
      {
        default = lib.mkOption {
          type = rangeDirectivesType;
          default = { };
          example = {
            default = {
              spoof = true;
            };
            "fport 6667" = {
              spoof = false;
              hide = true;
            };
            "lport 1024:" = {
              force.hide = true;
            };
          };
          description = ''
            Systemwide configuration for oidentd.

            See {manpage}`oidentd.conf(5)` for more details.
          '';
        };
        users = lib.mkOption {
          type = lib.types.attrsOf rangeDirectivesType;
          default = { };
          example = {
            "root" = {
              default = {
                hide = true;
              };
            };
            "alice" = {
              default = {
                hide = false;
              };
              "to irc.example.net fport 6667" = {
                force.reply = [ "me" ];
              };
            };
          };
          description = ''
            User-specific configuration for oidentd.

            See {manpage}`oidentd.conf(5)` for more details.
          '';
        };
      };

    masqSettings = lib.mkOption {
      type = lib.types.listOf (
        lib.types.submodule {
          options = {
            host = lib.mkOption {
              type = lib.types.str;
              description = "Hostname, IP address or network mask for this rule.";
            };
            response = lib.mkOption {
              type = lib.types.str;
              description = "The response to be send when receiveing a query for the host.";
            };
            system-type = lib.mkOption {
              type = lib.types.str;
              description = "The OS type send send along the Ident response.";
            };
          };
        }
      );
      default = [ ];
      example = [
        {
          host = "10.0.0.1";
          response = "user1";
          system-type = "UNIX";
        }
        {
          host = "server.internal";
          response = "user2";
          system-type = "UNIX-BSD";
        }
        {
          host = "10.0.0.0/24";
          response = "user3";
          system-type = "UNIX";
        }
        {
          host = "10.0.0.0/255.255.0.0";
          response = "user4";
          system-type = "UNKNOWN";
        }
      ];
      description = ''
        NAT rules for oidentd.

        See {manpage}`oidentd_masq.conf(5)` for more information.
      '';
    };

    extraFlags = lib.mkOption {
      type =
        with lib.types;
        attrsOf (oneOf [
          bool
          str
          int
        ]);
      default = { };
      example = {
        debug = true;
        error = true;
        timeout = 10;
      };
      description = ''
        Commandline flags to append when invoking `oidentd`.

        See {manpage}`oidentd(8)` for a list of available flags.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.oidentd.settings = {
      default.default = {
        spoof = lib.mkDefault false;
        spoof_all = lib.mkDefault false;
        spoof_privport = lib.mkDefault false;
        random = lib.mkDefault false;
        random_numeric = lib.mkDefault false;
        numeric = lib.mkDefault false;
        hide = lib.mkDefault false;
        forward = lib.mkDefault false;
      };
      users.root.default.force.hide = lib.mkDefault true;
    };

    environment.etc = {
      "oidentd/oidentd_masq.conf".text = lib.concatMapStringsSep "\n" (
        {
          host,
          response,
          system-type,
        }:
        "${host}\t${response}\t${system-type}"
      ) cfg.masqSettings;

      "oidentd/oidentd.conf".text =
        let
          quoteString = s: ''"${builtins.replaceStrings [ "\"" ] [ "\\\"" ] s}"'';

          indent = str: lib.concatStringsSep "\n" (map (l: "  ${l}") (lib.splitString "\n" str));

          capabilityStatementsToStrList =
            cs:
            (lib.optional (cs.forward != null) "forward ${cs.forward.host} ${toString cs.forward.port}")
            ++ (lib.optional cs.hide "hide")
            ++ (lib.optional cs.numeric "numeric")
            ++ (lib.optional cs.random "random")
            ++ (lib.optional cs.random_numeric "random_numeric")
            ++ (lib.optional (cs.reply != null) "reply ${lib.concatMapStringsSep " " quoteString cs.reply}");

          capabilityStatementsToStr = cs: lib.concatStringsSep "\n" (capabilityStatementsToStrList cs);

          capabilityDirectivesToStr =
            cds:
            let
              allowDeny =
                opt: lib.optional (cds.${opt} != null) "${if cds.${opt} then "allow" else "deny"} ${opt}";
            in
            lib.concatStringsSep "\n" (
              (allowDeny "forward")
              ++ (allowDeny "hide")
              ++ (allowDeny "numeric")
              ++ (allowDeny "random_numeric")
              ++ (allowDeny "spoof")
              ++ (allowDeny "spoof_all")
              ++ (allowDeny "spoof_privport")
              ++ map (x: "force ${x}") (capabilityStatementsToStrList cds.force)
            );

          rangeDirectivesToStr =
            rds:
            (lib.concatStringsSep "\n" (
              lib.mapAttrsToList (name: value: ''
                ${if name == "default" then "default" else quoteString name} {
                ${indent (capabilityDirectivesToStr value)}
                }'') rds
            ));

          userConfigToStr =
            users:
            lib.concatStringsSep "\n" (
              lib.mapAttrsToList (name: value: ''
                user ${quoteString name} {
                ${indent (rangeDirectivesToStr value)}
                }'') users
            );
        in
        ''
          default {
          ${indent (rangeDirectivesToStr cfg.settings.default)}
          }
          ${userConfigToStr cfg.settings.users}
        '';
    };

    systemd.sockets.oidentd = {
      documentation = [
        "man:oidentd(8)"
        "man:oidentd.conf(5)"
        "man:oidentd_masq.conf(5)"
      ];

      wantedBy = [ "sockets.target" ];

      inherit (cfg) listenStreams;

      socketConfig = {
        Accept = true;
        PrivateDevices = true;
      };
    };

    services.oidentd.extraFlags = {
      stdio = true;
      foreground = true;
      user = lib.mkDefault "nobody";
      group = lib.mkDefault "nogroup";
    };

    systemd.services."oidentd@" = {
      after = [ "network.target" ];

      reloadTriggers = [
        config.environment.etc."oidentd/oidentd.conf".source
        config.environment.etc."oidentd/oidentd_masq.conf".source
      ];

      serviceConfig =
        let
          masqueradingEnabled = lib.any (b: b) [
            (cfg.extraFlags.m or cfg.extraFlags.masq or false)
            (cfg.extraFlags.f or false != false)
            (cfg.extraFlags.forward or false != false)
          ];
        in
        {
          Type = "simple";
          StandardInput = "socket";
          StandardOutput = "socket";
          StandardError = "journal";
          Restart = "on-failure";
          ConfigurationDirectory = "oidentd";

          ExecStart =
            let
              flags = lib.cli.toCommandLineShellGNU { } cfg.extraFlags;
            in
            "${lib.getExe cfg.package} ${flags}";
          ExecReload = "${lib.getExe' pkgs.coreutils "kill"} -HUP $MAINPID";

          # Needs to see users to respond with identities.
          PrivateUsers = "full";

          # Allow the daemon to read configfiles in ~/.config/odidentd.conf and ~/.odidentd.conf
          ProtectHome = if cfg.grantHomeDirectoryAccess then "read-only" else "yes";
          # Even if we need access to /home and /root, we don't need /run/user
          InaccessiblePaths = lib.mkIf cfg.grantHomeDirectoryAccess [ "/run/user" ];

          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          NoNewPrivileges = true;
          PrivateDevices = true;
          PrivateTmp = "disconnected";
          ProtectClock = true;
          ProtectControlGroups = "strict";
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectProc = "noaccess";
          ProtectSystem = "strict";
          RemoveIPC = true;
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          SystemCallArchitectures = "native";
          SystemCallFilter = [
            "@system-service"
            "~@resources"
          ];
          UMask = "0777";

          RestrictAddressFamilies =
            if masqueradingEnabled then
              [
                "AF_INET"
                "AF_INET6"
                "AF_NETLINK"
              ]
            else
              [ "none" ];
        };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ 113 ];
    };
  };
}
