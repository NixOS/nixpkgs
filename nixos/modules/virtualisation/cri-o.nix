{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.virtualisation.cri-o;

  crioPackage = (pkgs.cri-o.override { inherit (cfg) extraPackages; });

  # Copy configuration files to avoid having the entire sources in the system closure
  copyFile = filePath: pkgs.runCommandNoCC (builtins.unsafeDiscardStringContext (builtins.baseNameOf filePath)) {} ''
    cp ${filePath} $out
  '';
in
{
  imports = [
    (mkRenamedOptionModule [ "virtualisation" "cri-o" "registries" ] [ "virtualisation" "containers" "registries" "search" ])
  ];

  meta = {
    maintainers = lib.teams.podman.members;
  };

  options.virtualisation.cri-o = {
    enable = mkEnableOption "Container Runtime Interface for OCI (CRI-O)";

    storageDriver = mkOption {
      type = types.enum [ "btrfs" "overlay" "vfs" ];
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
      example = [ "k8s.gcr.io/pause:3.2" ];
    };

    pauseCommand = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Override the default pause command";
      example = [ "/pause" ];
    };

    runtime = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Override the default runtime";
      example = [ "crun" ];
    };

    extraPackages = mkOption {
      type = with types; listOf package;
      default = [ ];
      example = lib.literalExample ''
        [
          pkgs.gvisor
        ]
      '';
      description = ''
        Extra packages to be installed in the CRI-O wrapper.
      '';
    };

    package = lib.mkOption {
      type = types.package;
      default = crioPackage;
      internal = true;
      description = ''
        The final CRI-O package (including extra packages).
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package pkgs.cri-tools ];

    environment.etc."crictl.yaml".source = copyFile "${pkgs.cri-o-unwrapped.src}/crictl.yaml";

    environment.etc."crio/crio.conf".text = ''
      [crio]
      storage_driver = "${cfg.storageDriver}"

      [crio.image]
      ${optionalString (cfg.pauseImage != null) ''pause_image = "${cfg.pauseImage}"''}
      ${optionalString (cfg.pauseCommand != null) ''pause_command = "${cfg.pauseCommand}"''}

      [crio.network]
      plugin_dirs = ["${pkgs.cni-plugins}/bin/"]

      [crio.runtime]
      cgroup_manager = "systemd"
      log_level = "${cfg.logLevel}"
      manage_ns_lifecycle = true

      ${optionalString (cfg.runtime != null) ''
      default_runtime = "${cfg.runtime}"
      [crio.runtime.runtimes]
      [crio.runtime.runtimes.${cfg.runtime}]
      ''}
    '';

    environment.etc."cni/net.d/10-crio-bridge.conf".source = copyFile "${pkgs.cri-o-unwrapped.src}/contrib/cni/10-crio-bridge.conf";

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
    };
  };
}
