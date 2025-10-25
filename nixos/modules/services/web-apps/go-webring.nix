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

  defaultAddress = "127.0.0.1:2857";
in

{
  options = {
    services.go-webring = {
      enable = mkEnableOption "go-webring";

      package = mkPackageOption pkgs "go-webring" { };

      contactInstructions = mkOption {
        type = types.nullOr types.str;
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
        type = types.str;
        description = ''
          This should be any HTML file with the string "{{ . }}" placed
          wherever you want the table of members inserted. This table is
          plain HTML so you can style it with CSS.
        '';
      };

      listenAddress = mkOption {
        type = types.str;
        default = defaultAddress;
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
    systemd.services.go-webring = {
      description = "go-webring service";
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
            --index ${pkgs.writeText "index.html" cfg.homePageTemplate} \
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
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
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
