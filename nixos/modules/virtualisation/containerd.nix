{ pkgs, lib, config, ... }:
let
  cfg = config.virtualisation.containerd;
  containerdConfigChecked = pkgs.runCommand "containerd-config-checked.toml" { nativeBuildInputs = [pkgs.containerd]; } ''
    containerd -c ${cfg.configFile} config dump >/dev/null
    ln -s ${cfg.configFile} $out
  '';
in
{

  options.virtualisation.containerd = with lib.types; {
    enable = lib.mkEnableOption "containerd container runtime";

    configFile = lib.mkOption {
      default = null;
      description = "path to containerd config file";
      type = nullOr path;
    };

    args = lib.mkOption {
      default = {};
      description = "extra args to append to the containerd cmdline";
      type = attrsOf str;
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.containerd.args.config = lib.mkIf (cfg.configFile != null) (toString containerdConfigChecked);

    environment.systemPackages = [pkgs.containerd];

    systemd.services.containerd = {
      description = "containerd - container runtime";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      path = with pkgs; [
        containerd
        runc
        iptables
      ];
      serviceConfig = {
        ExecStart = ''${pkgs.containerd}/bin/containerd ${lib.concatStringsSep " " (lib.cli.toGNUCommandLine {} cfg.args)}'';
        Delegate = "yes";
        KillMode = "process";
        Type = "notify";
        Restart = "always";
        RestartSec = "5";
        StartLimitBurst = "8";
        StartLimitIntervalSec = "120s";

        # "limits" defined below are adopted from upstream: https://github.com/containerd/containerd/blob/master/containerd.service
        LimitNPROC = "infinity";
        LimitCORE = "infinity";
        LimitNOFILE = "infinity";
        TasksMax = "infinity";
        OOMScoreAdjust = "-999";
      };
    };
  };
}
