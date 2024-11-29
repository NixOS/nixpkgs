{ config, lib, pkgs, ... }:
let
  cfg = config.services.rke2;
in
{
  imports = [ ];

  options.services.rke2 = {
    enable = lib.mkEnableOption "rke2";

    package = lib.mkPackageOption pkgs "rke2" { };

    role = lib.mkOption {
      type = lib.types.enum [ "server" "agent" ];
      description = ''
        Whether rke2 should run as a server or agent.

        If it's a server:

        - By default it also runs workloads as an agent.
        - any optionals is allowed.

        If it's an agent:

        - `serverAddr` is required.
        - `token` or `tokenFile` is required.
        - `agentToken` or `agentTokenFile` or `disable` or `cni` are not allowed.
      '';
      default = "server";
    };

    configPath = lib.mkOption {
      type = lib.types.path;
      description = "Load configuration from FILE.";
      default = "/etc/rancher/rke2/config.yaml";
    };

    debug = lib.mkOption {
      type = lib.types.bool;
      description = "Turn on debug logs.";
      default = false;
    };

    dataDir = lib.mkOption {
      type = lib.types.path;
      description = "The folder to hold state in.";
      default = "/var/lib/rancher/rke2";
    };

    token = lib.mkOption {
      type = lib.types.str;
      description = ''
        Shared secret used to join a server or agent to a cluster.

        > WARNING: This option will expose store your token unencrypted world-readable in the nix store.
        If this is undesired use the `tokenFile` option instead.
      '';
      default = "";
    };

    tokenFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      description = "File path containing rke2 token to use when connecting to the server.";
      default = null;
    };

    disable = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "Do not deploy packaged components and delete any deployed components.";
      default = [ ];
    };

    nodeName = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      description = "Node name.";
      default = null;
    };

    nodeLabel = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "Registering and starting kubelet with set of labels.";
      default = [ ];
    };

    nodeTaint = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "Registering kubelet with set of taints.";
      default = [ ];
    };

    nodeIP = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      description = "IPv4/IPv6 addresses to advertise for node.";
      default = null;
    };

    agentToken = lib.mkOption {
      type = lib.types.str;
      description = ''
        Shared secret used to join agents to the cluster, but not servers.

        > **WARNING**: This option will expose store your token unencrypted world-readable in the nix store.
        If this is undesired use the `agentTokenFile` option instead.
      '';
      default = "";
    };

    agentTokenFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      description = "File path containing rke2 agent token to use when connecting to the server.";
      default = null;
    };

    serverAddr = lib.mkOption {
      type = lib.types.str;
      description = "The rke2 server to connect to, used to join a cluster.";
      example = "https://10.0.0.10:6443";
      default = "";
    };

    selinux = lib.mkOption {
      type = lib.types.bool;
      description = "Enable SELinux in containerd.";
      default = false;
    };

    cni = lib.mkOption {
      type = lib.types.enum [ "none" "canal" "cilium" "calico" "flannel" ];
      description = ''
        CNI Plugins to deploy, one of `none`, `calico`, `canal`, `cilium` or `flannel`.

        All CNI plugins get installed via a helm chart after the main components are up and running
        and can be [customized by modifying the helm chart options](https://docs.rke2.io/helm).

        [Learn more about RKE2 and CNI plugins](https://docs.rke2.io/networking/basic_network_options)

        > **WARNING**: Flannel support in RKE2 is currently experimental.
      '';
      default = "canal";
    };

    cisHardening = lib.mkOption {
      type = lib.types.bool;
      description = ''
        Enable CIS Hardening for RKE2.

        It will set the configurations and controls required to address Kubernetes benchmark controls
        from the Center for Internet Security (CIS).

        Learn more about [CIS Hardening for RKE2](https://docs.rke2.io/security/hardening_guide).

        > **NOTICE**:
        >
        > You may need restart the `systemd-sysctl` muaually by:
        >
        > ```shell
        > sudo systemctl restart systemd-sysctl
        > ```
      '';
      default = false;
    };

    extraFlags = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = ''
        Extra flags to pass to the rke2 service/agent.

        Here you can find all the available flags:

        - [Server Configuration Reference](https://docs.rke2.io/reference/server_config)
        - [Agent Configuration Reference](https://docs.rke2.io/reference/linux_agent_config)
      '';
      example = [ "--disable-kube-proxy" "--cluster-cidr=10.24.0.0/16" ];
      default = [ ];
    };

    environmentVars = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      description = ''
        Environment variables for configuring the rke2 service/agent.

        Here you can find all the available environment variables:

        - [Server Configuration Reference](https://docs.rke2.io/reference/server_config)
        - [Agent Configuration Reference](https://docs.rke2.io/reference/linux_agent_config)

        Besides the options above, you can also active environment variables by edit/create those files:

        - `/etc/default/rke2`
        - `/etc/sysconfig/rke2`
        - `/usr/local/lib/systemd/system/rke2.env`
      '';
      # See: https://github.com/rancher/rke2/blob/master/bundle/lib/systemd/system/rke2-server.env#L1
      default = {
        HOME = "/root";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.role == "agent" -> (builtins.pathExists cfg.configPath || cfg.serverAddr != "");
        message = "serverAddr or configPath (with 'server' key) should be set if role is 'agent'";
      }
      {
        assertion = cfg.role == "agent" -> (builtins.pathExists cfg.configPath || cfg.tokenFile != null || cfg.token != "");
        message = "token or tokenFile or configPath (with 'token' or 'token-file' keys) should be set if role is 'agent'";
      }
      {
        assertion = cfg.role == "agent" -> ! (cfg.agentTokenFile != null || cfg.agentToken != "");
        message = "agentToken or agentTokenFile should be set if role is 'agent'";
      }
      {
        assertion = cfg.role == "agent" -> ! (cfg.disable != [ ]);
        message = "disable should not be set if role is 'agent'";
      }
      {
        assertion = cfg.role == "agent" -> ! (cfg.cni != "canal");
        message = "cni should not be set if role is 'agent'";
      }
    ];

    environment.systemPackages = [ config.services.rke2.package ];
    # To configure NetworkManager to ignore calico/flannel related network interfaces.
    # See: https://docs.rke2.io/known_issues#networkmanager
    environment.etc."NetworkManager/conf.d/rke2-canal.conf" = {
      enable = config.networking.networkmanager.enable;
      text = ''
        [keyfile]
        unmanaged-devices=interface-name:cali*;interface-name:flannel*
      '';
    };
    # See: https://docs.rke2.io/security/hardening_guide#set-kernel-parameters
    boot.kernel.sysctl = lib.mkIf cfg.cisHardening {
      "vm.panic_on_oom" = 0;
      "vm.overcommit_memory" = 1;
      "kernel.panic" = 10;
      "kernel.panic_on_oops" = 1;
    };

    systemd.services."rke2-${cfg.role}" = {
      description = "Rancher Kubernetes Engine v2";
      documentation = [ "https://github.com/rancher/rke2#readme" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = if cfg.role == "agent" then "exec" else "notify";
        EnvironmentFile = [
          "-/etc/default/%N"
          "-/etc/sysconfig/%N"
          "-/usr/local/lib/systemd/system/%N.env"
        ];
        Environment = lib.mapAttrsToList (k: v: "${k}=${v}") cfg.environmentVars;
        KillMode = "process";
        Delegate = "yes";
        LimitNOFILE = 1048576;
        LimitNPROC = "infinity";
        LimitCORE = "infinity";
        TasksMax = "infinity";
        TimeoutStartSec = 0;
        Restart = "always";
        RestartSec = "5s";
        ExecStartPre = [
          # There is a conflict between RKE2 and `nm-cloud-setup.service`. This service add a routing table that
          # interfere with the CNI plugin's configuration. This script checks if the service is enabled and if so,
          # failed the RKE2 start.
          # See: https://github.com/rancher/rke2/issues/1053
          (pkgs.writeScript "check-nm-cloud-setup.sh" ''
            #! ${pkgs.runtimeShell}
            set -x
            ! /run/current-system/systemd/bin/systemctl is-enabled --quiet nm-cloud-setup.service
          '')
          "-${pkgs.kmod}/bin/modprobe br_netfilter"
          "-${pkgs.kmod}/bin/modprobe overlay"
        ];
        ExecStart = "${cfg.package}/bin/rke2 '${cfg.role}' ${lib.escapeShellArgs (
             (lib.optional (cfg.configPath != "/etc/rancher/rke2/config.yaml") "--config=${cfg.configPath}")
          ++ (lib.optional cfg.debug "--debug")
          ++ (lib.optional (cfg.dataDir != "/var/lib/rancher/rke2") "--data-dir=${cfg.dataDir}")
          ++ (lib.optional (cfg.token != "") "--token=${cfg.token}")
          ++ (lib.optional (cfg.tokenFile != null) "--token-file=${cfg.tokenFile}")
          ++ (lib.optionals (cfg.role == "server" && cfg.disable != [ ]) (map (d: "--disable=${d}") cfg.disable))
          ++ (lib.optional (cfg.nodeName != null) "--node-name=${cfg.nodeName}")
          ++ (lib.optionals (cfg.nodeLabel != [ ]) (map (l: "--node-label=${l}") cfg.nodeLabel))
          ++ (lib.optionals (cfg.nodeTaint != [ ]) (map (t: "--node-taint=${t}") cfg.nodeTaint))
          ++ (lib.optional (cfg.nodeIP != null) "--node-ip=${cfg.nodeIP}")
          ++ (lib.optional (cfg.role == "server" && cfg.agentToken != "") "--agent-token=${cfg.agentToken}")
          ++ (lib.optional (cfg.role == "server" && cfg.agentTokenFile != null) "--agent-token-file=${cfg.agentTokenFile}")
          ++ (lib.optional (cfg.serverAddr != "") "--server=${cfg.serverAddr}")
          ++ (lib.optional cfg.selinux "--selinux")
          ++ (lib.optional (cfg.role == "server" && cfg.cni != "canal") "--cni=${cfg.cni}")
          ++ (lib.optional cfg.cisHardening "--profile=${if cfg.package.version >= "1.25" then "cis-1.23" else "cis-1.6"}")
          ++ cfg.extraFlags
        )}";
        ExecStopPost = let
          killProcess = pkgs.writeScript "kill-process.sh" ''
            #! ${pkgs.runtimeShell}
            /run/current-system/systemd/bin/systemd-cgls /system.slice/$1 | \
            ${pkgs.gnugrep}/bin/grep -Eo '[0-9]+ (containerd|kubelet)' | \
            ${pkgs.gawk}/bin/awk '{print $1}' | \
            ${pkgs.findutils}/bin/xargs -r ${pkgs.util-linux}/bin/kill
          '';
        in "-${killProcess} %n";
      };
    };
  };
}
