{
  config,
  lib,
  pkgs,
  utils,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkPackageOption
    mkOption
    mkIf
    mkDefault
    mkForce
    types
    optionals
    getExe
    ;
  inherit (utils) escapeSystemdExecArgs;
  cfg = config.services.apollo;

  # ports are offset from a single base port (Sunshine/Apollo convention)
  generatePorts = port: offsets: map (offset: port + offset) offsets;
  defaultPort = 47989;

  settingsFormat = pkgs.formats.keyValue { };
  configFile = settingsFormat.generate "apollo.conf" cfg.settings;
in
{
  options.services.apollo = with types; {
    enable = mkEnableOption "Apollo, a self-hosted game stream host for Moonlight / Artemis / Hestia clients";
    package = mkPackageOption pkgs "apollo" { };
    virtualDisplayBackend = mkOption {
      type = enum [
        "hermes_kms"
        "evdi"
      ];
      default = "hermes_kms";
      description = "Virtual display backend: hermes_kms (zero-copy, preferred) or evdi.";
    };
    settings = mkOption {
      default = { };
      description = ''
        Settings rendered into the Apollo configuration file. When set,
        configuration through the web UI is disabled.

        See <https://github.com/MrOz59/Hermes> for supported keys
        (Sunshine-compatible config format).
      '';
      type = submodule (settings: {
        freeformType = settingsFormat.type;
        options.port = mkOption {
          type = port;
          default = defaultPort;
          description = "Base port; others used are offset from this one.";
        };
      });
    };
    openFirewall = mkOption {
      type = bool;
      default = false;
      description = "Open the Apollo ports in the firewall.";
    };
    capSysAdmin = mkOption {
      type = bool;
      default = false;
      description = "Give the apollo binary CAP_SYS_ADMIN (required for DRM/KMS capture).";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    hardware.uinput.enable = true;

    # udev rules + modules-load.d shipped by the package
    services.udev.packages = [ cfg.package ];

    services.avahi = {
      enable = mkDefault true;
      publish = {
        enable = mkDefault true;
        userServices = mkDefault true;
      };
    };

    security.wrappers.apollo = mkIf cfg.capSysAdmin {
      owner = "root";
      group = "root";
      capabilities = "cap_sys_admin+p";
      source = getExe cfg.package;
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = generatePorts cfg.settings.port [
        (-5)
        0
        1
        21
      ];
      allowedUDPPorts = generatePorts cfg.settings.port [
        9
        10
        11
        13
        21
      ];
    };

    # user service: runs as whichever user holds the graphical session
    systemd.user.services.apollo = {
      description = "Apollo Game Streaming Service";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];

      startLimitIntervalSec = 500;
      startLimitBurst = 5;

      # don't use default PATH, needed for tray icon menu links
      environment.PATH = mkForce null;

      serviceConfig = {
        # the binary resolves SUNSHINE_ASSETS_DIR relative to the working dir
        WorkingDirectory = "${cfg.package}/share/apollo";
        ExecStart = escapeSystemdExecArgs (
          [
            (if cfg.capSysAdmin then "${config.security.wrapperDir}/apollo" else "${getExe cfg.package}")
          ]
          ++ optionals (builtins.length (builtins.attrNames cfg.settings) > 0) [ "${configFile}" ]
        );
        Environment = [ "VIRTUAL_DISPLAY_BACKEND=${cfg.virtualDisplayBackend}" ];
        Restart = "on-failure";
        RestartSec = "5s";
      };
    };
  };
}
