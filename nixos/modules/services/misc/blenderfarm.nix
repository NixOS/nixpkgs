{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.blendfarm;
  json = pkgs.formats.json { };
  configFile = json.generate "ServerSettings" (defaultConfig // cfg.serverConfig);
  defaultConfig = {
    Port = 15000;
    BroadcastPort = 16342;
    BypassScriptUpdate = false;
    BasicSecurityPassword = null;
  };
in
{
  meta.maintainers = with lib.maintainers; [ gador ];

  options.services.blendfarm = with lib.types; {
    enable = lib.mkEnableOption "Blendfarm, a render farm management software for Blender";
    package = lib.mkPackageOption pkgs "blendfarm" { };
    openFirewall = lib.mkEnableOption "allowing blendfarm network access through the firewall";

    user = lib.mkOption {
      description = "User under which blendfarm runs.";
      default = "blendfarm";
      type = str;
    };

    group = lib.mkOption {
      description = "Group under which blendfarm runs.";
      default = "blendfarm";
      type = str;
    };

    basicSecurityPasswordFile = lib.mkOption {
      description = ''
        Path to the password file the client needs to connect to the server.
              The password must not contain a forward slash.'';
      default = null;
      type = nullOr str;
    };

    blenderPackage = lib.mkPackageOption pkgs "blender" { };

    serverConfig = lib.mkOption {
      description = "Server configuration";
      default = defaultConfig;
      type = submodule {
        freeformType = attrsOf anything;
        options = {
          Port = lib.mkOption {
            description = "Default port blendfarm server listens on.";
            default = 15000;
            type = types.port;
          };
          BroadcastPort = lib.mkOption {
            description = "Default port blendfarm server advertises itself on.";
            default = 16342;
            type = types.port;
          };

          BypassScriptUpdate = lib.mkOption {
            description = "Prevents blendfarm from replacing the .py self-generated scripts.";
            default = false;
            type = bool;
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    networking.firewall = lib.optionalAttrs (cfg.openFirewall) {
      allowedTCPPorts = [ cfg.serverConfig.Port ];
      allowedUDPPorts = [ cfg.serverConfig.BroadcastPort ];
    };

    systemd.services.blendfarm-server = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      description = "blendfarm server";
      path = [ cfg.blenderPackage ];
      preStart =
        ''
          rm -f ServerSettings
          install -m640 ${configFile} ServerSettings
          if [ ! -d "BlenderData/nix-blender-linux64" ]; then
            mkdir -p BlenderData/nix-blender-linux64
            echo "nix-blender" > VersionCustom
          fi
          rm -f BlenderData/nix-blender-linux64/blender
          ln -s ${lib.getExe cfg.blenderPackage} BlenderData/nix-blender-linux64/blender
        ''
        + lib.optionalString (cfg.basicSecurityPasswordFile != null) ''
          BLENDFARM_PASSWORD=$(${pkgs.systemd}/bin/systemd-creds cat BLENDFARM_PASS_FILE)
          sed -i "s/null/\"$BLENDFARM_PASSWORD\"/g" ServerSettings
        '';
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/LogicReinc.BlendFarm.Server";
        DynamicUser = true;
        LogsDirectory = "blendfarm";
        StateDirectory = "blendfarm";
        WorkingDirectory = "/var/lib/blendfarm";
        User = cfg.user;
        Group = cfg.group;
        StateDirectoryMode = "0755";
        LoadCredential = lib.optional (
          cfg.basicSecurityPasswordFile != null
        ) "BLENDFARM_PASS_FILE:${cfg.basicSecurityPasswordFile}";
        ReadWritePaths = "";
        CapabilityBoundingSet = "";
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        PrivateDevices = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
          "@chown"
        ];
        RestrictRealtime = true;
        LockPersonality = true;
        UMask = "0066";
        ProtectHostname = true;
      };
    };

    users.users.blendfarm = {
      isSystemUser = true;
      group = "blendfarm";
    };
    users.groups.blendfarm = { };
  };
}
