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
    mkIf
    mkOption
    mkDefault
    types
    ;

  cfg = config.services.step-agent;
  settingsFormat = pkgs.formats.yaml { };
  settings = settingsFormat.generate "agent.yaml" cfg.settings;
in
{

  options = {
    services.step-agent = {
      enable = mkEnableOption "the smallstep certificate authority server";
      package = mkPackageOption pkgs "step-agent" { };
      settings = mkOption {
        type = types.submodule {
          freeformType = settingsFormat.type;
        };
        description = ''
          Settings that go into {file}`agent.yaml`. See
          `step-agent start --help`
          for more options'';
      };
      user = mkOption {
        type = types.str;
        default = "step-agent";
        description = "The user step-agent should run as.";
      };
      group = mkOption {
        type = types.str;
        default = "step-agent";
        description = "The group step-agent should run as.";
      };
    };
  };

  config = mkIf config.services.step-agent.enable {
    security.tpm2.enable = true;
    networking.wireless = {
      pkcs11.enable = true;
      enableHardening = mkDefault true;
    };

    systemd.services.wpa_supplicant = mkIf config.networking.wireless.enableHardening {
      serviceConfig = {
        BindPaths = [ "-/run/step-agent" ];
        BindReadOnlyPaths = [ "-/var/lib/step-agent/certificates" ];
        SupplementaryGroups = [ cfg.group ];
      };
    };

    environment.systemPackages = [ cfg.package ];

    systemd.sockets.step-agent-pkcs11 = {
      description = "Smallstep Agent PKCS#11 socket";
      documentation = [ "https://u.step.sm/docs/agent" ];
      wantedBy = [ "sockets.target" ];

      socketConfig = {
        ListenStream = "/run/step-agent/step-agent-pkcs11.sock";
        FileDescriptorName = "pkcs11";
        SocketUser = cfg.user;
        SocketGroup = cfg.group;

        SocketMode = "0666";
        Service = "step-agent.service";
      };
    };

    systemd.services.step-agent = {
      description = "Smallstep Agent";
      documentation = [
        "https://u.step.sm/docs/agent"
      ];
      wantedBy = [ "multi-user.target" ];
      after = [ "step-agent-pkcs11.socket" ];
      wants = [ "step-agent-pkcs11.socket" ];

      environment = {
        HOME = "/var/lib/step-agent";
        RUNTIME_DIRECTORY = "/run/step-agent";
      };

      serviceConfig = {
        SupplementaryGroups = [ "tss" ];
        Type = "notify";
        WatchdogSec = "60s";
        ExecStart = "${lib.getExe cfg.package} start --config ${settings}";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        User = cfg.user;
        Group = cfg.group;
        ConfigurationDirectory = "step-agent";
        StateDirectory = "step-agent";
        Restart = "always";
        RestartSec = 10;

        ProtectSystem = true;
        ProtectHome = "read-only";
        PrivateTmp = true;
        SecureBits = "keep-caps";
        AmbientCapabilities = [
          "CAP_IPC_LOCK"
          "CAP_CHOWN"
          "CAP_DAC_OVERRIDE"
          "CAP_FOWNER"
        ];
        CapabilityBoundingSet = [
          "CAP_SYSLOG"
          "CAP_IPC_LOCK"
          "CAP_CHOWN"
          "CAP_DAC_OVERRIDE"
          "CAP_FOWNER"
        ];
        DeviceAllow = [ "/dev/tpmrm0 rw" ];
        ReadWritePaths = [ "-/dev/tpmrm0" ];

        LimitNOFILE = 65536;
        LimitMEMLOCK = "infinity";
      };

    };

    systemd.tmpfiles.rules = [
      "d /run/step-agent 0750 ${cfg.user} ${cfg.group} - -"
    ];

    users.users."${cfg.user}" = {
      isSystemUser = true;
      group = cfg.group;
      home = "/var/lib/step-agent";
    };

    users.groups."${cfg.group}" = { };

    security.polkit.enable = true;
    security.polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
        if (subject.user == "${cfg.user}") {
          if (action.id == "org.freedesktop.systemd1.manage-units") {
            return polkit.Result.YES;
          }
          if (action.id.indexOf("org.freedesktop.NetworkManager.") == 0) {
            return polkit.Result.YES;
          }
        }
      });
    '';

    environment.etc."pkcs11/modules/step-agent.module".text = ''
      module: ${pkgs.p11-kit}/lib/pkcs11/p11-kit-client.so
      server-address: unix:path=/run/step-agent/step-agent-pkcs11.sock
    '';

  };

  meta.maintainers = with lib.maintainers; [
    Srylax
  ];
}
