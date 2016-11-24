{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.kubernetes;

in {

  ###### interface

  options.services.kubernetes = {
    package = mkOption {
      description = "Kubernetes package to use.";
      type = types.package;
    };

    verbose = mkOption {
      description = "Kubernetes enable verbose mode for debugging";
      default = false;
      type = types.bool;
    };

    etcdServers = mkOption {
      description = "Kubernetes list of etcd servers to watch.";
      default = [ "127.0.0.1:2379" ];
      type = types.listOf types.str;
    };

    roles = mkOption {
      description = ''
        Kubernetes role that this machine should take.

        Master role will enable etcd, apiserver, scheduler and controller manager
        services. Node role will enable etcd, docker, kubelet and proxy services.
      '';
      default = [];
      type = types.listOf (types.enum ["master" "node"]);
    };

    dataDir = mkOption {
      description = "Kubernetes root directory for managing kubelet files.";
      default = "/var/lib/kubernetes";
      type = types.path;
    };

    dockerCfg = mkOption {
      description = "Kubernetes contents of dockercfg file.";
      default = "";
      type = types.lines;
    };

    apiserver = {
      enable = mkOption {
        description = "Whether to enable kubernetes apiserver.";
        default = false;
        type = types.bool;
      };

      address = mkOption {
        description = "Kubernetes apiserver listening address.";
        default = "127.0.0.1";
        type = types.str;
      };

      publicAddress = mkOption {
        description = ''
          Kubernetes apiserver public listening address used for read only and
          secure port.
        '';
        default = cfg.apiserver.address;
        type = types.str;
      };

      port = mkOption {
        description = "Kubernetes apiserver listening port.";
        default = 8080;
        type = types.int;
      };

      securePort = mkOption {
        description = "Kubernetes apiserver secure port.";
        default = 6443;
        type = types.int;
      };

      tlsCertFile = mkOption {
        description = "Kubernetes apiserver certificate file.";
        default = "";
        type = types.str;
      };

      tlsPrivateKeyFile = mkOption {
        description = "Kubernetes apiserver private key file.";
        default = "";
        type = types.str;
      };

      clientCaFile = mkOption {
        description = "Kubernetes apiserver CA file for client auth.";
        default = "";
        type = types.str;
      };

      tokenAuth = mkOption {
        description = ''
          Kubernetes apiserver token authentication file. See
          <link xlink:href="http://kubernetes.io/v1.0/docs/admin/authentication.html"/>
        '';
        default = {};
        example = literalExample ''
          {
            alice = "abc123";
            bob = "xyz987";
          }
        '';
        type = types.attrsOf types.str;
      };

      authorizationMode = mkOption {
        description = ''
          Kubernetes apiserver authorization mode (AlwaysAllow/AlwaysDeny/ABAC). See
          <link xlink:href="http://kubernetes.io/v1.0/docs/admin/authorization.html"/>
        '';
        default = "AlwaysAllow";
        type = types.enum ["AlwaysAllow" "AlwaysDeny" "ABAC"];
      };

      authorizationPolicy = mkOption {
        description = ''
          Kubernetes apiserver authorization policy file. See
          <link xlink:href="http://kubernetes.io/v1.0/docs/admin/authorization.html"/>
        '';
        default = [];
        example = literalExample ''
          [
            {user = "admin";}
            {user = "scheduler"; readonly = true; kind= "pods";}
            {user = "scheduler"; kind = "bindings";}
            {user = "kubelet";  readonly = true; kind = "bindings";}
            {user = "kubelet"; kind = "events";}
            {user= "alice"; ns = "projectCaribou";}
            {user = "bob"; readonly = true; ns = "projectCaribou";}
          ]
        '';
        type = types.listOf types.attrs;
      };

      allowPrivileged = mkOption {
        description = "Whether to allow privileged containers on kubernetes.";
        default = false;
        type = types.bool;
      };

      portalNet = mkOption {
        description = "Kubernetes CIDR notation IP range from which to assign portal IPs";
        default = "10.10.10.10/16";
        type = types.str;
      };

      runtimeConfig = mkOption {
        description = ''
          Api runtime configuration. See
          <link xlink:href="http://kubernetes.io/v1.0/docs/admin/cluster-management.html"/>
        '';
        default = "";
        example = "api/all=false,api/v1=true";
        type = types.str;
      };

      admissionControl = mkOption {
        description = ''
          Kubernetes admission control plugins to use. See
          <link xlink:href="http://kubernetes.io/v1.0/docs/admin/admission-controllers.html"/>
        '';
        default = ["AlwaysAdmit"];
        example = [
          "NamespaceLifecycle" "NamespaceExists" "LimitRanger"
          "SecurityContextDeny" "ServiceAccount" "ResourceQuota"
        ];
        type = types.listOf types.str;
      };

      serviceAccountKey = mkOption {
        description = ''
          Kubernetes apiserver PEM-encoded x509 RSA private or public key file,
          used to verify ServiceAccount tokens.
        '';
        default = null;
        type = types.nullOr types.path;
      };

      extraOpts = mkOption {
        description = "Kubernetes apiserver extra command line options.";
        default = "";
        type = types.str;
      };
    };

    scheduler = {
      enable = mkOption {
        description = "Whether to enable kubernetes scheduler.";
        default = false;
        type = types.bool;
      };

      address = mkOption {
        description = "Kubernetes scheduler listening address.";
        default = "127.0.0.1";
        type = types.str;
      };

      port = mkOption {
        description = "Kubernetes scheduler listening port.";
        default = 10251;
        type = types.int;
      };

      master = mkOption {
        description = "Kubernetes apiserver address";
        default = "${cfg.apiserver.address}:${toString cfg.apiserver.port}";
        type = types.str;
      };

      extraOpts = mkOption {
        description = "Kubernetes scheduler extra command line options.";
        default = "";
        type = types.str;
      };
    };

    controllerManager = {
      enable = mkOption {
        description = "Whether to enable kubernetes controller manager.";
        default = false;
        type = types.bool;
      };

      address = mkOption {
        description = "Kubernetes controller manager listening address.";
        default = "127.0.0.1";
        type = types.str;
      };

      port = mkOption {
        description = "Kubernetes controller manager listening port.";
        default = 10252;
        type = types.int;
      };

      master = mkOption {
        description = "Kubernetes apiserver address";
        default = "${cfg.apiserver.address}:${toString cfg.apiserver.port}";
        type = types.str;
      };

      serviceAccountPrivateKey = mkOption {
        description = ''
          Kubernetes controller manager PEM-encoded private RSA key file used to
          sign service account tokens
        '';
        default = null;
        type = types.nullOr types.path;
      };

      rootCaFile = mkOption {
        description = ''
          Kubernetes controller manager certificate authority file included in
          service account's token secret.
        '';
        default = null;
        type = types.nullOr types.path;
      };

      extraOpts = mkOption {
        description = "Kubernetes controller manager extra command line options.";
        default = "";
        type = types.str;
      };
    };

    kubelet = {
      enable = mkOption {
        description = "Whether to enable kubernetes kubelet.";
        default = false;
        type = types.bool;
      };

      registerNode = mkOption {
        description = "Whether to auto register kubelet with API server.";
        default = true;
        type = types.bool;
      };

      address = mkOption {
        description = "Kubernetes kubelet info server listening address.";
        default = "0.0.0.0";
        type = types.str;
      };

      port = mkOption {
        description = "Kubernetes kubelet info server listening port.";
        default = 10250;
        type = types.int;
      };

      healthz = {
        bind = mkOption {
          description = "Kubernetes kubelet healthz listening address.";
          default = "127.0.0.1";
          type = types.str;
        };

        port = mkOption {
          description = "Kubernetes kubelet healthz port.";
          default = 10248;
          type = types.int;
        };
      };

      hostname = mkOption {
        description = "Kubernetes kubelet hostname override";
        default = config.networking.hostName;
        type = types.str;
      };

      allowPrivileged = mkOption {
        description = "Whether to allow kubernetes containers to request privileged mode.";
        default = false;
        type = types.bool;
      };

      apiServers = mkOption {
        description = ''
          Kubernetes kubelet list of Kubernetes API servers for publishing events,
          and reading pods and services.
        '';
        default = ["${cfg.apiserver.address}:${toString cfg.apiserver.port}"];
        type = types.listOf types.str;
      };

      cadvisorPort = mkOption {
        description = "Kubernetes kubelet local cadvisor port.";
        default = 4194;
        type = types.int;
      };

      clusterDns = mkOption {
        description = "Use alternative dns.";
        default = "";
        type = types.str;
      };

      clusterDomain = mkOption {
        description = "Use alternative domain.";
        default = "kubernetes.io";
        type = types.str;
      };

      extraOpts = mkOption {
        description = "Kubernetes kubelet extra command line options.";
        default = "";
        type = types.str;
      };
    };

    proxy = {
      enable = mkOption {
        description = "Whether to enable kubernetes proxy.";
        default = false;
        type = types.bool;
      };

      address = mkOption {
        description = "Kubernetes proxy listening address.";
        default = "0.0.0.0";
        type = types.str;
      };

      master = mkOption {
        description = "Kubernetes apiserver address";
        default = "${cfg.apiserver.address}:${toString cfg.apiserver.port}";
        type = types.str;
      };

      extraOpts = mkOption {
        description = "Kubernetes proxy extra command line options.";
        default = "";
        type = types.str;
      };
    };

    kube2sky = {
      enable = mkEnableOption "Whether to enable kube2sky dns service.";

      domain = mkOption  {
        description = "Kuberntes kube2sky domain under which all DNS names will be hosted.";
        default = cfg.kubelet.clusterDomain;
        type = types.str;
      };

      master = mkOption {
        description = "Kubernetes apiserver address";
        default = "${cfg.apiserver.address}:${toString cfg.apiserver.port}";
        type = types.str;
      };

      extraOpts = mkOption {
        description = "Kubernetes kube2sky extra command line options.";
        default = "";
        type = types.str;
      };
    };
  };

  ###### implementation

  config = mkMerge [
    (mkIf cfg.apiserver.enable {
      systemd.services.kube-apiserver = {
        description = "Kubernetes Api Server";
        wantedBy = [ "multi-user.target" ];
        requires = ["kubernetes-setup.service"];
        after = [ "network.target" "etcd.service" "kubernetes-setup.service" ];
        serviceConfig = {
          ExecStart = let
            authorizationPolicyFile =
              pkgs.writeText "kubernetes-policy"
                (builtins.toJSON cfg.apiserver.authorizationPolicy);
            tokenAuthFile =
              pkgs.writeText "kubernetes-auth"
                (concatImapStringsSep "\n" (i: v: v + "," + (toString i))
                    (mapAttrsToList (name: token: token + "," + name) cfg.apiserver.tokenAuth));
          in ''${cfg.package}/bin/kube-apiserver \
            --etcd-servers=${concatMapStringsSep "," (f: "http://${f}") cfg.etcdServers} \
            --insecure-bind-address=${cfg.apiserver.address} \
            --insecure-port=${toString cfg.apiserver.port} \
            --bind-address=${cfg.apiserver.publicAddress} \
            --allow-privileged=${if cfg.apiserver.allowPrivileged then "true" else "false"} \
            ${optionalString (cfg.apiserver.tlsCertFile!="")
              "--tls-cert-file=${cfg.apiserver.tlsCertFile}"} \
            ${optionalString (cfg.apiserver.tlsPrivateKeyFile!="")
              "--tls-private-key-file=${cfg.apiserver.tlsPrivateKeyFile}"} \
            ${optionalString (cfg.apiserver.tokenAuth!=[])
              "--token-auth-file=${tokenAuthFile}"} \
            ${optionalString (cfg.apiserver.clientCaFile!="")
              "--client-ca-file=${cfg.apiserver.clientCaFile}"} \
            --authorization-mode=${cfg.apiserver.authorizationMode} \
            ${optionalString (cfg.apiserver.authorizationMode == "ABAC")
              "--authorization-policy-file=${authorizationPolicyFile}"} \
            --secure-port=${toString cfg.apiserver.securePort} \
            --service-cluster-ip-range=${cfg.apiserver.portalNet} \
            ${optionalString (cfg.apiserver.runtimeConfig!="")
              "--runtime-config=${cfg.apiserver.runtimeConfig}"} \
            --admission_control=${concatStringsSep "," cfg.apiserver.admissionControl} \
            ${optionalString (cfg.apiserver.serviceAccountKey!=null)
              "--service-account-key-file=${cfg.apiserver.serviceAccountKey}"} \
            --logtostderr=true \
            ${optionalString cfg.verbose "--v=6 --log-flush-frequency=1s"} \
            ${cfg.apiserver.extraOpts}
          '';
          User = "kubernetes";
        };
      };
    })

    (mkIf cfg.scheduler.enable {
      systemd.services.kube-scheduler = {
        description = "Kubernetes Scheduler Service";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" "kubernetes-apiserver.service" ];
        serviceConfig = {
          ExecStart = ''${cfg.package}/bin/kube-scheduler \
            --address=${cfg.scheduler.address} \
            --port=${toString cfg.scheduler.port} \
            --master=${cfg.scheduler.master} \
            --logtostderr=true \
            ${optionalString cfg.verbose "--v=6 --log-flush-frequency=1s"} \
            ${cfg.scheduler.extraOpts}
          '';
          User = "kubernetes";
        };
      };
    })

    (mkIf cfg.controllerManager.enable {
      systemd.services.kube-controller-manager = {
        description = "Kubernetes Controller Manager Service";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" "kubernetes-apiserver.service" ];
        serviceConfig = {
          ExecStart = ''${cfg.package}/bin/kube-controller-manager \
            --address=${cfg.controllerManager.address} \
            --port=${toString cfg.controllerManager.port} \
            --master=${cfg.controllerManager.master} \
            ${optionalString (cfg.controllerManager.serviceAccountPrivateKey!=null)
              "--service-account-private-key-file=${cfg.controllerManager.serviceAccountPrivateKey}"} \
            ${optionalString (cfg.controllerManager.rootCaFile!=null)
              "--root-ca-file=${cfg.controllerManager.rootCaFile}"} \
            --logtostderr=true \
            ${optionalString cfg.verbose "--v=6 --log-flush-frequency=1s"} \
            ${cfg.controllerManager.extraOpts}
          '';
          User = "kubernetes";
        };
      };
    })

    (mkIf cfg.kubelet.enable {
      systemd.services.kubelet = {
        description = "Kubernetes Kubelet Service";
        wantedBy = [ "multi-user.target" ];
        requires = ["kubernetes-setup.service"];
        after = [ "network.target" "etcd.service" "docker.service" "kubernetes-setup.service" ];
        path = [ pkgs.gitMinimal pkgs.openssh ];
        script = ''
          export PATH="/bin:/sbin:/usr/bin:/usr/sbin:$PATH"
          exec ${cfg.package}/bin/kubelet \
            --api-servers=${concatMapStringsSep "," (f: "http://${f}") cfg.kubelet.apiServers}  \
            --register-node=${if cfg.kubelet.registerNode then "true" else "false"} \
            --address=${cfg.kubelet.address} \
            --port=${toString cfg.kubelet.port} \
            --healthz-bind-address=${cfg.kubelet.healthz.bind} \
            --healthz-port=${toString cfg.kubelet.healthz.port} \
            --hostname-override=${cfg.kubelet.hostname} \
            --allow-privileged=${if cfg.kubelet.allowPrivileged then "true" else "false"} \
            --root-dir=${cfg.dataDir} \
            --cadvisor_port=${toString cfg.kubelet.cadvisorPort} \
            ${optionalString (cfg.kubelet.clusterDns != "")
                ''--cluster-dns=${cfg.kubelet.clusterDns}''} \
            ${optionalString (cfg.kubelet.clusterDomain != "")
                ''--cluster-domain=${cfg.kubelet.clusterDomain}''} \
            --logtostderr=true \
            ${optionalString cfg.verbose "--v=6 --log_flush_frequency=1s"} \
            ${cfg.kubelet.extraOpts}
          '';
        serviceConfig.WorkingDirectory = cfg.dataDir;
      };
    })

    (mkIf cfg.proxy.enable {
      systemd.services.kube-proxy = {
        description = "Kubernetes Proxy Service";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" "etcd.service" ];
        serviceConfig = {
          ExecStart = ''${cfg.package}/bin/kube-proxy \
            --master=${cfg.proxy.master} \
            --bind-address=${cfg.proxy.address} \
            --logtostderr=true \
            ${optionalString cfg.verbose "--v=6 --log-flush-frequency=1s"} \
            ${cfg.proxy.extraOpts}
          '';
          Restart = "always"; # Retry connection
          RestartSec = "5s";
        };
      };
    })

    (mkIf cfg.kube2sky.enable {
      systemd.services.kube2sky = {
        description = "Kubernetes Dns Bridge Service";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" "skydns.service" "etcd.service" "kubernetes-apiserver.service" ];
        serviceConfig = {
          ExecStart = ''${cfg.package}/bin/kube2sky \
            -etcd-server=http://${head cfg.etcdServers} \
            -domain=${cfg.kube2sky.domain} \
            -kube_master_url=http://${cfg.kube2sky.master} \
            -logtostderr=true \
            ${optionalString cfg.verbose "--v=6 --log-flush-frequency=1s"} \
            ${cfg.kube2sky.extraOpts}
          '';
          User = "kubernetes";
        };
      };
    })

    (mkIf (any (el: el == "master") cfg.roles) {
      services.kubernetes.apiserver.enable = mkDefault true;
      services.kubernetes.scheduler.enable = mkDefault true;
      services.kubernetes.controllerManager.enable = mkDefault true;
      services.kubernetes.kube2sky.enable = mkDefault true;
    })

    (mkIf (any (el: el == "node") cfg.roles) {
      virtualisation.docker.enable = mkDefault true;
      services.kubernetes.kubelet.enable = mkDefault true;
      services.kubernetes.proxy.enable = mkDefault true;
    })

    (mkIf (any (el: el == "node" || el == "master") cfg.roles) {
      services.etcd.enable = mkDefault true;

      services.skydns.enable = mkDefault true;
      services.skydns.domain = mkDefault cfg.kubelet.clusterDomain;
    })

    (mkIf (
        cfg.apiserver.enable ||
        cfg.scheduler.enable ||
        cfg.controllerManager.enable ||
        cfg.kubelet.enable ||
        cfg.proxy.enable
    ) {
      systemd.services.kubernetes-setup = {
        description = "Kubernetes setup.";
        serviceConfig.Type = "oneshot";
        script = ''
          mkdir -p /var/run/kubernetes
          chown kubernetes /var/lib/kubernetes

          rm ${cfg.dataDir}/.dockercfg || true
          ln -fs ${pkgs.writeText "kubernetes-dockercfg" cfg.dockerCfg} ${cfg.dataDir}/.dockercfg
        '';
      };

      services.kubernetes.package = mkDefault pkgs.kubernetes;

      environment.systemPackages = [ cfg.package ];

      users.extraUsers = singleton {
        name = "kubernetes";
        uid = config.ids.uids.kubernetes;
        description = "Kubernetes user";
        extraGroups = [ "docker" ];
        group = "kubernetes";
        home = cfg.dataDir;
        createHome = true;
      };
      users.extraGroups.kubernetes.gid = config.ids.gids.kubernetes;
    })

  ];
}
