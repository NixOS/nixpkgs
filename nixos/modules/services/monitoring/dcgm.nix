{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.services.dcgm;
in {
  options.services.dcgm = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        NVIDIA Data Center GPU Manager (DCGM).
        Runs as a background process to manage GPUs on the node.
        Provides interface to address queries from DCGMI tool.
      '';
    };

    port = mkOption {
      type = types.port;
      default = 5555;
      description = lib.mdDoc ''
        Specify the port for the Host Engine.
      '';
    };

    domainSocket = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = lib.mdDoc ''
        Specify the Unix domain socket path for host engine.
        No TCP listening port is opened when this option is specified.
      '';
    };

    bindInterface = mkOption {
      type = types.str;
      default = "127.0.0.1";
      description = lib.mdDoc ''
        Specify the IP address of the network interface that the host engine should listen on.

        ALL = bind to all interfaces.

        NOTE: This must be an IP address. Do not use a hostname.
      '';
    };

    pid = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = lib.mdDoc ''
        Specify the PID filename nv-hostengine should use to ensure that only one instance is running.
      '';
    };

    logLevel = mkOption {
      type = types.enum [
        "NONE"
        "FATAL"
        "ERROR"
        "WARN"
        "INFO"
        "DEBUG"
      ];
      default = "ERROR";
      description = lib.mdDoc ''
        Specify the logging level.
      '';
    };

    logFilename = mkOption {
      type = types.path;
      default = "${config.services.dcgm.homeDir}/nv-hostengine.log";
      defaultText = literalExpression ''
        ''${config.services.dcgm.homeDir}/nv-hostengine.log"
      '';
      description = lib.mdDoc ''
        Specify the filename nv-hostengine should use to dump logging information.
      '';
    };

    logRotate = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Rotate the log file if the log file with the same name already exists.
      '';
    };

    denylistModules = mkOption {
      type = types.nullOr types.commas;
      default = null;
      description = lib.mdDoc ''
        DCGM modules that should be added to the Denylist so they aren't run by the hostengine.
        Pass a comma-separated list of module IDs like 1,2,3.
        Module IDs are available in dcgm_structs.h as DcgmModuleId constants.
      '';
    };

    serviceAccount = mkOption {
      type = types.str;
      default = "dcgm";
      description = lib.mdDoc ''
        Service account that will be used for unprivileged processes.
        Usually this should be set to the default nvidia-dcgm account.
      '';
    };

    homeDir = mkOption {
      type = types.path;
      default = "/var/lib/dcgm";
      description = lib.mdDoc ''
        The full path to the directory that the DCGM diagnostic should be launched from.
        This becomes the default output directory for DCGM diagnostic log and stats files.
      '';
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Open the firewall for the port.
      '';
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      # TODO(@connorbaker): Look at
      # https://github.com/nix-community/queued-build-hook/blob/6a69b97d2951e3440f209930cde0464d7754274c/module.nix
      # for an example service which uses a socket.

      # TODO(@connorbaker): Currently complaining about being run as non-root. We can't run it as the service account?

      # TODO(@connorbaker): Current errors: (get new copy)

      systemd.services.dcgm = {
        description = "NVIDIA Data Center GPU Manager (DCGM)";
        wantedBy = ["multi-user.target"];
        after = ["network.target"];
        environment = {
          # NOTE: Add the libnvidia-ml.so.1 and libnvidia_nscq.so libraries to the LD_LIBRARY_PATH
          # using the current NVIDIA driver.
          # If we don't we get a failure here:
          # https://github.com/NVIDIA/DCGM/blob/7e1012302679e4bb7496483b32dcffb56e528c92/sdk/nvidia/nvml/nvml_loader/nvml_loader.cpp#L199-L212.
          # The underlying problem is that DCGM expects the library to be in certain paths:
          # https://github.com/NVIDIA/DCGM/blob/7e1012302679e4bb7496483b32dcffb56e528c92/sdk/nvidia/nvml/nvml_loader/nvml_loader.cpp#L126-L131.
          LD_LIBRARY_PATH = "${config.hardware.nvidia.package}/lib";
          DCGM_HOME_DIR = cfg.homeDir;
        };
        serviceConfig = {
          # TODO(@connorbaker): Upstream's systemd config template is here: https://github.com/NVIDIA/DCGM/blob/7e1012302679e4bb7496483b32dcffb56e528c92/config-files/systemd/nvidia-dcgm.service.in
          # TODO(@connorbaker): Are these relevant?
          # AmbientCapabilities = ["CAP_SYS_ADMIN"];
          # CapabilityBoundingSet = ["CAP_SYS_ADMIN"];

          WorkingDirectory = cfg.homeDir;
          # User = cfg.serviceAccount;
          # Group = cfg.serviceAccount;
          # TODO(@connorbaker): What does systemd say the different between runtime and working directory are?
          # RuntimeDirectory = cfg.serviceAccount;
          # RuntimeDirectoryMode = "0755";

          # Restart = "always";
          # RestartSec = "5s";
          # TODO(@connorbaker): What is DynamicUser?
          # DynamicUser = true;
          ExecStart = lib.concatStringsSep " \\\n  " (
            [
              "${lib.getBin pkgs.dcgm}/bin/nv-hostengine"
              "--port ${toString cfg.port}"
            ]
            ++ lib.optionals (cfg.domainSocket != null) ["--domain-socket ${cfg.domainSocket}"]
            ++ ["--bind-interface ${cfg.bindInterface}"]
            ++ lib.optionals (cfg.pid != null) ["--pid ${cfg.pid}"]
            ++ [
              "--log-level ${cfg.logLevel}"
              "--log-filename ${cfg.logFilename}"
            ]
            ++ lib.optionals cfg.logRotate ["--log-rotate"]
            ++ lib.optionals (cfg.denylistModules != null) ["--denylist-modules ${cfg.denylistModules}"]
            ++ [
              "--service-account ${cfg.serviceAccount}"
              "--home-dir ${cfg.homeDir}"
            ]
          );
        };
      };

      users = {
        users.${cfg.serviceAccount} = {
          description = "DCGM daemon user";
          createHome = true;
          group = cfg.serviceAccount;
          home = cfg.homeDir;
          isSystemUser = true;
        };
        groups.${cfg.serviceAccount} = {};
      };
    })

    (mkIf (cfg.enable && cfg.openFirewall) {
      networking.firewall.allowedTCPPorts = [cfg.port];
    })
  ];
}
