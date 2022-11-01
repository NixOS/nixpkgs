{ pkgs, lib, config, ... }:
let
  cfg = config.virtualisation.containerd;
  proxy_env = config.networking.proxy.envVars;

  configFile =
    if cfg.configFile == null then
      settingsFormat.generate "containerd.toml" cfg.settings
    else
      cfg.configFile;

  containerdConfigChecked = pkgs.runCommand "containerd-config-checked.toml"
    {
      nativeBuildInputs = [ pkgs.containerd ];
    } ''
    containerd -c ${configFile} config dump >/dev/null
    ln -s ${configFile} $out
  '';

  settingsFormat = pkgs.formats.toml { };

  containerdUnit = "containerd.service";
in
{

  options.virtualisation.containerd = with lib.types; {
    enable = lib.mkEnableOption (lib.mdDoc "containerd container runtime");

    package = lib.mkOption {
      default = pkgs.containerd;
      defaultText = lib.literalExpression "pkgs.containerd";
      type = types.package;
      description = lib.mdDoc ''
        containerd package to be used in the module.
      '';
    };

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
      default = { };
      description = lib.mdDoc ''
        Verbatim lines to add to containerd.toml
      '';
    };

    args = lib.mkOption {
      default = { };
      description = lib.mdDoc "extra args to append to the containerd cmdline";
      type = attrsOf str;
    };

    nerdctl.enable = lib.mkOption {
      type = bool;
      default = true;
      example = false;
      description = lib.mdDoc "Whether to enable nerdctl rootless mode.";
    };

    nerdctl.package = lib.mkOption {
      default = pkgs.nerdctl;
      defaultText = lib.literalExpression "pkgs.nerdctl";
      type = types.package;
      description = lib.mdDoc "nerdctl package to be used in the module.";
    };

    nerdctl.portDriver = lib.mkOption {
      default = "builtin";
      defaultText = lib.literalExpression "pkgs.nerdctl";
      type = types.enum [ "builtin" "slirp4netns" ];
      description = lib.mdDoc "Port driver to be used";
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

    environment.systemPackages = [ cfg.package ]
      ++ lib.optional cfg.nerdctl.enable cfg.nerdctl.package;

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

        # "limits" defined below are adopted from upstream: https://github.com/containerd/containerd/blob/main/containerd.service
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

    # User services adapted from
    # https://github.com/containerd/nerdctl/blob/master/extras/rootless/containerd-rootless-setuptool.sh
    systemd.user.services = lib.mkIf (cfg.nerdctl.enable) {
      containerd = {
        wantedBy = [ "default.target" ];

        description = "containerd (Rootless)";
        environment = {
          CONTAINERD_ROOTLESS_ROOTLESSKIT_PORT_DRIVER = cfg.nerdctl.portDriver;
        };
        # needs newuidmap
        path = [ "/run/wrappers" ]
          ++ lib.optional config.boot.zfs.enabled config.boot.zfs.package;
        unitConfig = {
          ConditionUser = "!root";
          StartLimitInterval = "60s";
        };

        serviceConfig = {
          ExecStart = "${pkgs.nerdctl}/bin/containerd-rootless";
          ExecReload = "${pkgs.procps}/bin/kill -s HUP $MAINPID";
          TimeoutSec = 0;
          RestartSec = 2;
          Restart = "always";
          StartLimitBurst = 3;
          LimitNOFILE = "infinity";
          LimitNPROC = "infinity";
          LimitCORE = "infinity";
          TasksMax = "infinity";
          Delegate = true;
          Type = "simple";
          KillMode = "mixed";
        };
      };


      buildkit = {
        wantedBy = [ "default.target" ];

        description = "BuildKit (Rootless)";
        partOf = [ containerdUnit ];
        path = with pkgs; [ buildkit coreutils util-linux ];
        serviceConfig =
          let
            # Helper script:
            # https://github.com/containerd/nerdctl/blob/884dc5480da0c4db5e2e18b008a9a7578af59b51/extras/rootless/containerd-rootless-setuptool.sh#L142-L147
            nsenterScript = pkgs.writeShellScript "nsenter"
              ''
                pid=$(cat "$XDG_RUNTIME_DIR/containerd-rootless/child_pid")
                exec nsenter --no-fork --wd="$(pwd)" --preserve-credentials -m -n -U -t "$pid" -- "$@"
              '';
          in
          {
            ExecStart = "${nsenterScript} buildkitd";
            ExecReload = "kill -s HUP $MAINPID";
            RestartSec = 2;
            Restart = "always";
            Type = "simple";
            KillMode = "mixed";
          };
      };
    };
  };
}
