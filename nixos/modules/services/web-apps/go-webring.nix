{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkPackageOption
    mkOption
    types
    literalExpression
    mkIf
    ;
  cfg = config.services.go-webring;
in

{
  options = {
    services.go-webring = {
      enable = mkEnableOption "go-webring";

      package = mkPackageOption pkgs "go-webring" { };

      contactInstructions = mkOption {
        type = types.nullOr types.lines;
        default = null;
        description = "Contact instructions for errors";
        example = "contact the admin and let them know what's up";
      };

      host = mkOption {
        type = types.str;
        description = "Host this webring runs on, primarily used for validation";
        example = "my-webri.ng";
      };

      homePageTemplate = mkOption {
        type = types.path;
        description = ''
          This should be any HTML file with the string "{{ . }}" placed
          wherever you want the table of members inserted. This table is
          plain HTML so you can style it with CSS.

          Note: This option expects a file path, not inline HTML content. If you want to provide inline HTML as a template, you can use `pkgs.writeText` to create a file.
        '';
      };

      listenAddress = mkOption {
        type = types.str;
        default = "127.0.0.1:2857";
        description = "Host and port go-webring will listen on";
      };

      members = mkOption {
        type = types.listOf (
          types.submodule {
            options = {
              username = mkOption {
                type = types.str;
                description = "Member's name";
              };
              site = mkOption {
                type = types.str;
                description = "Member's site URL";
              };
            };
          }
        );
        description = "List of members in the webring";
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion =
          let
            usernames = lib.map (member: member.username) cfg.members;
            uniqueUsernames = lib.unique usernames;
          in
          lib.length usernames == lib.length uniqueUsernames;
        message = "All go-webring member usernames must be unique.";
      }
    ];

    systemd.services.go-webring = {
      description = "Simple Webring HTTP Service";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      requires = [ "network.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = ''
          ${lib.getExe cfg.package} \
            ${
              lib.optionalString (cfg.contactInstructions != null) (
                "--contact " + lib.escapeShellArg cfg.contactInstructions
              )
            } \
            --host ${cfg.host} \
            --index ${cfg.homePageTemplate} \
            --listen ${cfg.listenAddress} \
            --members ${
              pkgs.writeText "list.txt" (
                lib.concatMapStrings (member: member.username + " " + member.site + "\n") cfg.members
              )
            }
        '';
        User = "go-webring";
        DynamicUser = true;
        RuntimeDirectory = "go-webring";
        WorkingDirectory = "/var/lib/go-webring";
        StateDirectory = "go-webring";
        RuntimeDirectoryMode = "0750";
        Restart = "always";
        RestartSec = 5;

        # Hardening
        CapabilityBoundingSet = [ "" ];
        DeviceAllow = [ "" ];
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        PrivateDevices = true;
        PrivateUsers = true;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = "strict";
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
        ];
        UMask = "0077";
      };
    };
    environment.systemPackages = [ cfg.package ];
  };
}
