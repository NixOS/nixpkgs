{ pkgs, lib, config, ... }:
let
  cfg = config.virtualisation.containerd;

  configFile = if cfg.configFile == null then
    settingsFormat.generate "containerd.toml" cfg.settings
  else
    cfg.configFile;

  containerdConfigChecked = pkgs.runCommand "containerd-config-checked.toml" {
    nativeBuildInputs = [ pkgs.containerd ];
  } ''
    containerd -c ${configFile} config dump >/dev/null
    ln -s ${configFile} $out
  '';

  settingsFormat = pkgs.formats.toml {};
in
{

  options.virtualisation.containerd = with lib.types; {
    enable = lib.mkEnableOption "containerd container runtime";

    configFile = lib.mkOption {
      default = null;
      description = lib.mdDoc ''
       Path to containerd config file.
       Setting this option will override any configuration applied by the settings option.
      '';
      type = nullOr path;
    };

    settings = lib.mkOption {
      type = settingsFormat.type;
      default = {};
      description = lib.mdDoc ''
        Verbatim lines to add to containerd.toml
      '';
    };

    args = lib.mkOption {
      default = {};
      description = lib.mdDoc "extra args to append to the containerd cmdline";
      type = attrsOf str;
    };
  };

  config = lib.mkIf cfg.enable {
    warnings = lib.optional (cfg.configFile != null) ''
      `virtualisation.containerd.configFile` is deprecated. use `virtualisation.containerd.settings` instead.
    '';

    virtualisation.containerd = {
      args.config = toString containerdConfigChecked;
      settings = {
        version = 2;
        plugins."io.containerd.grpc.v1.cri" = {
         containerd.snapshotter =
           lib.mkIf config.boot.zfs.enabled (lib.mkOptionDefault "zfs");
         cni.bin_dir = lib.mkOptionDefault "${pkgs.cni-plugins}/bin";
        };
      };
    };

    environment.systemPackages = [ pkgs.containerd ];

    systemd.services.containerd = {
      description = "containerd - container runtime";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      path = with pkgs; [
        containerd
        runc
        iptables
      ] ++ lib.optional config.boot.zfs.enabled config.boot.zfs.package;
      serviceConfig = {
        ExecStart = ''${pkgs.containerd}/bin/containerd ${lib.concatStringsSep " " (lib.cli.toGNUCommandLine {} cfg.args)}'';
        Delegate = "yes";
        KillMode = "process";
        Type = "notify";
        Restart = "always";
        RestartSec = "10";

        # "limits" defined below are adopted from upstream: https://github.com/containerd/containerd/blob/master/containerd.service
        LimitNPROC = "infinity";
        LimitCORE = "infinity";
        LimitNOFILE = "infinity";
        TasksMax = "infinity";
        OOMScoreAdjust = "-999";

        StateDirectory = "containerd";
        RuntimeDirectory = "containerd";
        RuntimeDirectoryPreserve = "yes";
      };
      unitConfig = {
        StartLimitBurst = "16";
        StartLimitIntervalSec = "120s";
      };
    };
  };
}
