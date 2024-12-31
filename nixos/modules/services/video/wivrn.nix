{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkPackageOption
    mkOption
    optionalString
    optionalAttrs
    isDerivation
    recursiveUpdate
    getExe
    literalExpression
    types
    maintainers
    ;
  cfg = config.services.wivrn;
  configFormat = pkgs.formats.json { };

  # For the application option to work with systemd PATH, we find the store binary path of
  # the package, concat all of the following strings, and then update the application attribute.

  # Since the json config attribute type "configFormat.type" doesn't allow specifying types for
  # individual attributes, we have to type check manually.

  # The application option must be either a package or a list with package as the first element.

  # Checking if an application is provided
  applicationAttrExists = builtins.hasAttr "application" cfg.config.json;
  applicationListNotEmpty = (
    if builtins.isList cfg.config.json.application then
      (builtins.length cfg.config.json.application) != 0
    else
      true
  );
  applicationCheck = applicationAttrExists && applicationListNotEmpty;

  # Manage packages and their exe paths
  applicationAttr = (
    if builtins.isList cfg.config.json.application then
      builtins.head cfg.config.json.application
    else
      cfg.config.json.application
  );
  applicationPackage = mkIf applicationCheck applicationAttr;
  applicationPackageExe = getExe applicationAttr;
  serverPackageExe = getExe cfg.package;

  # Managing strings
  applicationStrings = builtins.tail cfg.config.json.application;
  applicationConcat = (
    if builtins.isList cfg.config.json.application then
      builtins.concatStringsSep " " ([ applicationPackageExe ] ++ applicationStrings)
    else
      applicationPackageExe
  );

  # Manage config file
  applicationUpdate = recursiveUpdate cfg.config.json (
    optionalAttrs applicationCheck { application = applicationConcat; }
  );
  configFile = configFormat.generate "config.json" applicationUpdate;
  enabledConfig = optionalString cfg.config.enable "-f ${configFile}";

  # Manage server executables and flags
  serverExec = builtins.concatStringsSep " " (
    [
      serverPackageExe
      "--systemd"
      enabledConfig
    ]
    ++ cfg.extraServerFlags
  );
  applicationExec = builtins.concatStringsSep " " (
    [
      serverPackageExe
      "--application"
      enabledConfig
    ]
    ++ cfg.extraApplicationFlags
  );
in
{
  options = {
    services.wivrn = {
      enable = mkEnableOption "WiVRn, an OpenXR streaming application";

      package = mkPackageOption pkgs "wivrn" { };

      openFirewall = mkEnableOption "the default ports in the firewall for the WiVRn server";

      defaultRuntime = mkEnableOption ''
        WiVRn Monado as the default OpenXR runtime on the system.
        The config can be found at `/etc/xdg/openxr/1/active_runtime.json`.

        Note that applications can bypass this option by setting an active
        runtime in a writable XDG_CONFIG_DIRS location like `~/.config`
      '';

      autoStart = mkEnableOption "starting the service by default";

      monadoEnvironment = mkOption {
        type = types.attrs;
        description = "Environment variables to be passed to the Monado environment.";
        default = {
          XRT_COMPOSITOR_LOG = "debug";
          XRT_PRINT_OPTIONS = "on";
          IPC_EXIT_ON_DISCONNECT = "off";
        };
      };

      extraServerFlags = mkOption {
        type = types.listOf types.str;
        description = "Flags to add to the wivrn service.";
        default = [ ];
        example = ''[ "--no-publish-service" ]'';
      };

      extraApplicationFlags = mkOption {
        type = types.listOf types.str;
        description = "Flags to add to the wivrn-application service. This is NOT the WiVRn startup application.";
        default = [ ];
      };

      extraPackages = mkOption {
        type = types.listOf types.package;
        description = "Packages to add to the wivrn-application service $PATH.";
        default = [ ];
        example = literalExpression "[ pkgs.bash pkgs.procps ]";
      };

      config = {
        enable = mkEnableOption "configuration for WiVRn";
        json = mkOption {
          type = configFormat.type;
          description = ''
            Configuration for WiVRn. The attributes are serialized to JSON in config.json. If a config or certain attributes are not provided, the server will default to stock values.

            Note that the application option must be either a package or a
            list with package as the first element.

            See https://github.com/WiVRn/WiVRn/blob/master/docs/configuration.md
          '';
          default = { };
          example = literalExpression ''
            {
              scale = 0.5;
              bitrate = 100000000;
              encoders = [
                {
                  encoder = "nvenc";
                  codec = "h264";
                  width = 1.0;
                  height = 1.0;
                  offset_x = 0.0;
                  offset_y = 0.0;
                }
              ];
              application = [ pkgs.wlx-overlay-s ];
            }
          '';
        };
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = !applicationCheck || isDerivation applicationAttr;
        message = "The application in WiVRn configuration is not a package. Please ensure that the application is a package or that a package is the first element in the list.";
      }
    ];

    systemd.user = {
      services = {
        # The WiVRn server runs in a hardened service and starts the application in a different service
        wivrn = {
          description = "WiVRn XR runtime service";
          environment = {
            # Default options
            # https://gitlab.freedesktop.org/monado/monado/-/blob/598080453545c6bf313829e5780ffb7dde9b79dc/src/xrt/targets/service/monado.in.service#L12
            XRT_COMPOSITOR_LOG = "debug";
            XRT_PRINT_OPTIONS = "on";
            IPC_EXIT_ON_DISCONNECT = "off";
          } // cfg.monadoEnvironment;
          serviceConfig = {
            ExecStart = serverExec;
            # Hardening options
            CapabilityBoundingSet = [ "CAP_SYS_NICE" ];
            AmbientCapabilities = [ "CAP_SYS_NICE" ];
            LockPersonality = true;
            NoNewPrivileges = true;
            PrivateTmp = true;
            ProtectClock = true;
            ProtectControlGroups = true;
            ProtectKernelLogs = true;
            ProtectKernelModules = true;
            ProtectKernelTunables = true;
            ProtectProc = "invisible";
            ProtectSystem = "strict";
            RemoveIPC = true;
            RestrictNamespaces = true;
            RestrictSUIDSGID = true;
          };
          wantedBy = mkIf cfg.autoStart [ "default.target" ];
          restartTriggers = [ cfg.package ];
        };
        wivrn-application = mkIf applicationCheck {
          description = "WiVRn application service";
          requires = [ "wivrn.service" ];
          serviceConfig = {
            ExecStart = applicationExec;
            Restart = "on-failure";
            RestartSec = 0;
            PrivateTmp = true;
          };
          path = [ applicationPackage ] ++ cfg.extraPackages;
        };
      };
    };

    services = {
      udev.packages = with pkgs; [ android-udev-rules ];
      avahi = {
        enable = true;
        publish = {
          enable = true;
          userServices = true;
        };
      };
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ 9757 ];
      allowedUDPPorts = [ 9757 ];
    };

    environment = {
      systemPackages = [
        cfg.package
        applicationPackage
      ];
      pathsToLink = [ "/share/openxr" ];
      etc."xdg/openxr/1/active_runtime.json" = mkIf cfg.defaultRuntime {
        source = "${cfg.package}/share/openxr/1/openxr_wivrn.json";
      };
    };
  };
  meta.maintainers = with maintainers; [ passivelemon ];
}
