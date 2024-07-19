{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.virtualisation.cri-o;

  crioPackage = pkgs.cri-o.override {
    extraPackages = cfg.extraPackages
      ++ lib.optional (config.boot.supportedFilesystems.zfs or false) config.boot.zfs.package;
  };

  format = pkgs.formats.toml { };

  cfgFile = format.generate "00-default.conf" cfg.settings;
in
{
  meta = {
    maintainers = teams.podman.members;
  };

  options.virtualisation.cri-o = {
    enable = mkEnableOption "Container Runtime Interface for OCI (CRI-O)";

    storageDriver = mkOption {
      type = types.enum [ "aufs" "btrfs" "devmapper" "overlay" "vfs" "zfs" ];
      default = "overlay";
      description = "Storage driver to be used";
    };

    logLevel = mkOption {
      type = types.enum [ "trace" "debug" "info" "warn" "error" "fatal" ];
      default = "info";
      description = "Log level to be used";
    };

    pauseImage = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Override the default pause image for pod sandboxes";
      example = "k8s.gcr.io/pause:3.2";
    };

    pauseCommand = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Override the default pause command";
      example = "/pause";
    };

    runtime = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Override the default runtime";
      example = "crun";
    };

    extraPackages = mkOption {
      type = with types; listOf package;
      default = [ ];
      example = literalExpression ''
        [
          pkgs.gvisor
        ]
      '';
      description = ''
        Extra packages to be installed in the CRI-O wrapper.
      '';
    };

    package = mkOption {
      type = types.package;
      default = crioPackage;
      internal = true;
      description = ''
        The final CRI-O package (including extra packages).
      '';
    };

    networkDir = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "Override the network_dir option.";
      internal = true;
    };

    settings = mkOption {
      type = format.type;
      default = { };
      description = ''
        Configuration for cri-o, see
        <https://github.com/cri-o/cri-o/blob/master/docs/crio.conf.5.md>.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package pkgs.cri-tools ];

    environment.etc."crictl.yaml".source = "${cfg.package}/etc/crictl.yaml";

    virtualisation.cri-o.settings.crio = {
      storage_driver = cfg.storageDriver;

      image = {
        pause_image = mkIf (cfg.pauseImage != null) cfg.pauseImage;
        pause_command = mkIf (cfg.pauseCommand != null) cfg.pauseCommand;
      };

      network = {
        plugin_dirs = [ "${pkgs.cni-plugins}/bin" ];
        network_dir = mkIf (cfg.networkDir != null) cfg.networkDir;
      };

      runtime = {
        cgroup_manager = "systemd";
        log_level = cfg.logLevel;
        manage_ns_lifecycle = true;
        pinns_path = "${cfg.package}/bin/pinns";
        hooks_dir =
          optional (config.virtualisation.containers.ociSeccompBpfHook.enable)
            config.boot.kernelPackages.oci-seccomp-bpf-hook;

        default_runtime = mkIf (cfg.runtime != null) cfg.runtime;
        runtimes = mkIf (cfg.runtime != null) {
          "${cfg.runtime}" = { };
        };
      };
    };

    environment.etc."cni/net.d/10-crio-bridge.conflist".source = "${cfg.package}/etc/cni/net.d/10-crio-bridge.conflist";
    environment.etc."cni/net.d/99-loopback.conflist".source = "${cfg.package}/etc/cni/net.d/99-loopback.conflist";
    environment.etc."crio/crio.conf.d/00-default.conf".source = cfgFile;

    # Enable common /etc/containers configuration
    virtualisation.containers.enable = true;

    systemd.services.crio = {
      description = "Container Runtime Interface for OCI (CRI-O)";
      documentation = [ "https://github.com/cri-o/cri-o" ];
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      path = [ cfg.package ];
      serviceConfig = {
        Type = "notify";
        ExecStart = "${cfg.package}/bin/crio";
        ExecReload = "/bin/kill -s HUP $MAINPID";
        TasksMax = "infinity";
        LimitNOFILE = "1048576";
        LimitNPROC = "1048576";
        LimitCORE = "infinity";
        OOMScoreAdjust = "-999";
        TimeoutStartSec = "0";
        Restart = "on-abnormal";
      };
      restartTriggers = [ cfgFile ];
    };
  };
}
