{ config
, lib
, pkgs
, ...
}:
let
  cfg = config.services.blenderfarm;
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

  options.services.blenderfarm = with lib.types; {
    enable = lib.mkEnableOption "Blenderfarm, a render farm management software for Blender.";
    package = lib.mkPackageOption pkgs "blenderfarm" { };
    openFirewall = lib.mkEnableOption "Allow blenderfarm network access through the firewall.";

    user = lib.mkOption {
      description = "User under which blenderfarm runs.";
      default = "blenderfarm";
      type = str;
    };

    group = lib.mkOption {
      description = "Group under which blenderfarm runs.";
      default = "blenderfarm";
      type = str;
    };

    basicSecurityPasswordFile = lib.mkOption {
      description = ''Path to the password file the client needs to connect to the server.
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
            description = "Default port blenderfarm server listens on.";
            default = 15000;
            type = types.port;
          };
          BroadcastPort = lib.mkOption {
            description = "Default port blenderfarm server advertises itself on.";
            default = 16342;
            type = types.port;
          };

          BypassScriptUpdate = lib.mkOption {
            description = "Prevents blenderfarm from replacing the .py self-generated scripts.";
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

    systemd.services.blenderfarm-server = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      description = "blenderfarm server";
      path = [ cfg.blenderPackage ];
      preStart = ''
        rm -f ServerSettings
        install -m640 ${configFile} ServerSettings
        if [ ! -d "BlenderData/nix-blender-linux64" ]; then
          mkdir -p BlenderData/nix-blender-linux64
          echo "nix-blender" > VersionCustom
        fi
        rm -f BlenderData/nix-blender-linux64/blender
        ln -s ${lib.getExe cfg.blenderPackage} BlenderData/nix-blender-linux64/blender
      '' +
      lib.optionalString (cfg.basicSecurityPasswordFile != null) ''
        BLENDERFARM_PASSWORD=$(${pkgs.systemd}/bin/systemd-creds cat BLENDERFARM_PASS_FILE)
        sed -i "s/null/\"$BLENDERFARM_PASSWORD\"/g" ServerSettings
      '';
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/LogicReinc.BlendFarm.Server";
        DynamicUser = true;
        LogsDirectory = "blenderfarm";
        StateDirectory = "blenderfarm";
        WorkingDirectory = "/var/lib/blenderfarm";
        User = cfg.user;
        Group = cfg.group;
        StateDirectoryMode = "0755";
        LoadCredential = lib.optional (cfg.basicSecurityPasswordFile != null) "BLENDERFARM_PASS_FILE:${cfg.basicSecurityPasswordFile}";
        ReadWritePaths = "";
        CapabilityBoundingSet = "";
        RestrictAddressFamilies = [ "AF_UNIX" "AF_INET" "AF_INET6" ];
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

    users.users.blenderfarm = {
      isSystemUser = true;
      group = "blenderfarm";
    };
    users.groups.blenderfarm = { };
  };
}
