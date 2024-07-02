{ config, pkgs, lib, ... }:
let
  inherit (lib) mkAliasOptionModule mkIf mkEnableOption mkPackageOption mkOption mkDefault optional optionalString optionalAttrs isDerivation getExe literalExpression maintainers;
  cfg = config.services.wivrn;
  configFormat = pkgs.formats.json { };

  # For the application option to work with systemd PATH, we find the store binary path of
  # the package, concat all of the following strings, and then update the application attribute.
  # Application can either be a package or a list that has a package as the first element.
  applicationExists = builtins.hasAttr "application" cfg.config.json;
  applicationListNotEmpty = (
    if builtins.isList cfg.config.json.application
    then if builtins.length cfg.config.json.application == 0
      then false
      else true
    else true
  );
  applicationCheck = applicationExists && applicationListNotEmpty;

  applicationBinary = (
    if builtins.isList cfg.config.json.application
    then (builtins.head cfg.config.json.application)
    else cfg.config.json.application
  );
  applicationStrings = builtins.tail cfg.config.json.application;

  applicationPath = mkIf applicationCheck applicationBinary;

  applicationConcat = (
    if builtins.isList cfg.config.json.application
    then builtins.concatStringsSep " " ([ (getExe applicationBinary) ] ++ applicationStrings)
    else (getExe applicationBinary)
  );
  applicationUpdate = cfg.config.json // optionalAttrs applicationCheck { application = applicationConcat; };
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
      '' // { default = true; };

      highPriority = mkEnableOption "high priority capability for asynchronous reprojection" // { default = true; };

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

  imports = [
    (mkAliasOptionModule [ "services" "wivrn" "monadoEnvironment" ] [ "systemd" "user" "services" "wivrn" "environment" ])
  ];

  config = mkIf cfg.enable {
    assertions = [
      (mkIf applicationCheck {
        assertion = isDerivation applicationBinary;
        message = "The application in WiVRn configuration is not a package. Please ensure that the application is a package or that a package is the first element in the list.";
      })
    ];

    security.wrappers."wivrn-server" = mkIf cfg.highPriority {
      setuid = false;
      owner = "root";
      group = "root";
      # We need cap_sys_nice for asynchronous reprojection
      capabilities = "cap_sys_nice+eip";
      source = getExe cfg.package;
    };

    systemd.user = {
      services.wivrn = {
        description = "WiVRn XR runtime service module";
        unitConfig.ConditionUser = "!root";
        serviceConfig = {
          ExecStart = (
            if cfg.highPriority
            then "${config.security.wrapperDir}/wivrn-server"
            else getExe cfg.package
          ) + optionalString cfg.config.enable " -f ${configFile}";
          Restart = "no";
        };
        # We need to add the application to PATH so WiVRn can find it
        path = [ applicationPath ];
        restartTriggers = [
          cfg.package
          configFile
        ];
      };
    };

    services = {
      wivrn.monadoEnvironment = {
        # Default options
        # https://gitlab.freedesktop.org/monado/monado/-/blob/598080453545c6bf313829e5780ffb7dde9b79dc/src/xrt/targets/service/monado.in.service#L12
        XRT_COMPOSITOR_LOG = mkDefault "debug";
        XRT_PRINT_OPTIONS = mkDefault "on";
        IPC_EXIT_ON_DISCONNECT = mkDefault "off";
      };
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
      systemPackages = [ cfg.package ];
      pathsToLink = [ "/share/openxr" ];
      etc."xdg/openxr/1/active_runtime.json" = mkIf cfg.defaultRuntime {
        source = "${cfg.package}/share/openxr/1/openxr_wivrn.json";
      };
    };
  };
  meta.maintainers = with maintainers; [ passivelemon ];
}
