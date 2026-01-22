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
    literalExpression
    hasAttr
    toList
    length
    head
    tail
    concatStringsSep
    optionalString
    optionalAttrs
    isDerivation
    recursiveUpdate
    getExe
    types
    maintainers
    ;
  cfg = config.services.wivrn;
  configFormat = pkgs.formats.json { };

  # For the application option to work with systemd PATH, we find the store binary path of
  # the package, concat all of the following strings, and then update the application attribute.

  # Since the json config attribute type "configFormat.type" doesn't allow specifying types for
  # individual attributes, we have to type check manually.

  # The application option should be a list with package as the first element, though a single package is also valid.
  # Note that this module depends on the package containing the meta.mainProgram attribute.

  # Check if an application is provided
  applicationAttrExists = hasAttr "application" cfg.config.json;
  applicationList = toList cfg.config.json.application;
  applicationListNotEmpty = length applicationList != 0;
  applicationCheck = applicationAttrExists && applicationListNotEmpty;

  # Manage packages and their exe paths
  applicationAttr = head applicationList;
  applicationPackage = mkIf applicationCheck applicationAttr;
  applicationPackageExe = getExe applicationAttr;
  serverPackageExe = (
    if cfg.highPriority then "${config.security.wrapperDir}/wivrn-server" else getExe cfg.package
  );

  # Manage strings
  applicationStrings = tail applicationList;
  applicationConcat = concatStringsSep " " ([ applicationPackageExe ] ++ applicationStrings);

  # Manage config file
  applicationUpdate = recursiveUpdate cfg.config.json (
    optionalAttrs applicationCheck { application = applicationConcat; }
  );
  configFile = configFormat.generate "config.json" applicationUpdate;
  enabledConfig = optionalString cfg.config.enable "-f ${configFile}";

  # Manage server executables and flags
  serverExec = concatStringsSep " " (
    [
      serverPackageExe
      "--systemd"
      enabledConfig
    ]
    ++ cfg.extraServerFlags
  );
in
{
  options = {
    services.wivrn = {
      enable = mkEnableOption "WiVRn, an OpenXR streaming application";

      package = mkPackageOption pkgs "wivrn" { };

      openFirewall = mkEnableOption "the default ports in the firewall for the WiVRn server";

      defaultRuntime = mkEnableOption ''
        WiVRn as the default OpenXR runtime on the system.
        The config can be found at `/etc/xdg/openxr/1/active_runtime.json`.

        Note that applications can bypass this option by setting an active
        runtime in a writable XDG_CONFIG_DIRS location like `~/.config`
      '';

      autoStart = mkEnableOption "starting the service by default";

      highPriority = mkEnableOption "high priority capability for asynchronous reprojection";

      monadoEnvironment = mkOption {
        type = types.attrs;
        description = "Environment variables to be passed to the Monado environment.";
        default = { };
      };

      extraServerFlags = mkOption {
        type = types.listOf types.str;
        description = "Flags to add to the wivrn service.";
        default = [ ];
        example = literalExpression ''[ "--no-publish-service" ]'';
      };

      steam = {
        importOXRRuntimes = mkEnableOption ''
          Sets `PRESSURE_VESSEL_IMPORT_OPENXR_1_RUNTIMES` system-wide to allow Steam to automatically discover the WiVRn server.

          Note that you may have to logout for this variable to be visible
        '';

        package = mkPackageOption pkgs "steam" { };
      };

      config = {
        enable = mkEnableOption "configuration for WiVRn";
        json = mkOption {
          type = configFormat.type;
          description = ''
            Configuration for WiVRn. The attributes are serialized to JSON in config.json. The server will fallback to default values for any missing attributes.

            Like upstream, the application option is a list including the application and it's flags. In the case of the NixOS module however, the first element of the list must be a package. The module will assert otherwise.
            The application can be set to a single package because it gets passed to lib.toList, though this will not allow for flags to be passed.

            See <https://github.com/WiVRn/WiVRn/blob/master/docs/configuration.md>
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

    security.wrappers."wivrn-server" = mkIf cfg.highPriority {
      setuid = false;
      owner = "root";
      group = "root";
      capabilities = "cap_sys_nice+eip";
      source = getExe cfg.package;
    };

    systemd.user = {
      services = {
        wivrn = {
          description = "WiVRn XR runtime service";
          environment = recursiveUpdate {
            # Default options
            # https://gitlab.freedesktop.org/monado/monado/-/blob/598080453545c6bf313829e5780ffb7dde9b79dc/src/xrt/targets/service/monado.in.service#L12
            XRT_COMPOSITOR_LOG = "debug";
            XRT_PRINT_OPTIONS = "on";
            IPC_EXIT_ON_DISCONNECT = "off";
            PRESSURE_VESSEL_IMPORT_OPENXR_1_RUNTIMES = mkIf cfg.steam.importOXRRuntimes "1";
          } cfg.monadoEnvironment;
          serviceConfig = (
            if cfg.highPriority then
              {
                ExecStart = serverExec;
              }
            # Hardening options break high-priority
            else
              {
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
              }
          );
          path = [ cfg.steam.package ];
          wantedBy = mkIf cfg.autoStart [ "default.target" ];
          restartTriggers = [
            cfg.package
            cfg.steam.package
          ];
        };
      };
    };

    services = {
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

    services.firewalld.packages = [ cfg.package ];

    environment = {
      systemPackages = [
        cfg.package
        applicationPackage
      ];
      sessionVariables = mkIf cfg.steam.importOXRRuntimes {
        PRESSURE_VESSEL_IMPORT_OPENXR_1_RUNTIMES = "1";
      };
      pathsToLink = [ "/share/openxr" ];
      etc."xdg/openxr/1/active_runtime.json" = mkIf cfg.defaultRuntime {
        source = "${cfg.package}/share/openxr/1/openxr_wivrn.json";
      };
    };
  };
  meta.maintainers = with maintainers; [ passivelemon ];
}
