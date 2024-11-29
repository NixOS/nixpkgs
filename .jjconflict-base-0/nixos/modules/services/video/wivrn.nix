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
  # Application can either be a package or a list that has a package as the first element.
  applicationExists = builtins.hasAttr "application" cfg.config.json;
  applicationListNotEmpty = (
    if builtins.isList cfg.config.json.application then
      (builtins.length cfg.config.json.application) != 0
    else
      true
  );
  applicationCheck = applicationExists && applicationListNotEmpty;

  applicationBinary = (
    if builtins.isList cfg.config.json.application then
      builtins.head cfg.config.json.application
    else
      cfg.config.json.application
  );
  applicationStrings = builtins.tail cfg.config.json.application;

  applicationPath = mkIf applicationCheck applicationBinary;

  applicationConcat = (
    if builtins.isList cfg.config.json.application then
      builtins.concatStringsSep " " ([ (getExe applicationBinary) ] ++ applicationStrings)
    else
      (getExe applicationBinary)
  );
  applicationUpdate = recursiveUpdate cfg.config.json (
    optionalAttrs applicationCheck { application = applicationConcat; }
  );
  configFile = configFormat.generate "config.json" applicationUpdate;
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
            Configuration for WiVRn. The attributes are serialized to JSON in config.json.

            Note that the application option must be either a package or a
            list with package as the first element.

            See https://github.com/Meumeu/WiVRn/blob/master/docs/configuration.md
          '';
          default = { };
          example = literalExpression ''
            {
              scale = 0.8;
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
              tcp_only = true;
            }
          '';
        };
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = !applicationCheck || isDerivation applicationBinary;
        message = "The application in WiVRn configuration is not a package. Please ensure that the application is a package or that a package is the first element in the list.";
      }
    ];

    systemd.user = {
      services = {
        # The WiVRn server runs in a hardened service and starts the applications in a different service
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
            ExecStart = (
              (getExe cfg.package) + " --systemd" + optionalString cfg.config.enable " -f ${configFile}"
            );
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
          restartTriggers = [
            cfg.package
            configFile
          ];
        };
        wivrn-application = mkIf applicationCheck {
          description = "WiVRn application service";
          requires = [ "wivrn.service" ];
          serviceConfig = {
            ExecStart = (
              (getExe cfg.package) + " --application" + optionalString cfg.config.enable " -f ${configFile}"
            );
            Restart = "on-failure";
            RestartSec = 0;
            PrivateTmp = true;
          };
          # We need to add the application to PATH so WiVRn can find it
          path = [ applicationPath ] ++ cfg.extraPackages;
        };
      };
    };

    services = {
      # WiVRn can be used with some wired headsets so we include xr-hardware
      udev.packages = with pkgs; [
        android-udev-rules
        xr-hardware
      ];
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
        applicationPath
      ];
      pathsToLink = [ "/share/openxr" ];
      etc."xdg/openxr/1/active_runtime.json" = mkIf cfg.defaultRuntime {
        source = "${cfg.package}/share/openxr/1/openxr_wivrn.json";
      };
    };
  };
  meta.maintainers = with maintainers; [ passivelemon ];
}
