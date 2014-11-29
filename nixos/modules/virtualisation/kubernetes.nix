{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.virtualisation.kubernetes;

in {

  ###### interface

  options.virtualisation.kubernetes = {
    package = mkOption {
      description = "Kubernetes package to use.";
      default = pkgs.kubernetes;
      type = types.package;
    };

    verbose = mkOption {
      description = "Kubernetes enable verbose mode for debugging";
      default = false;
      type = types.bool;
    };

    etcdServers = mkOption {
      description = "Kubernetes list of etcd servers to watch.";
      default = [ "127.0.0.1:4001" ];
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
        description = "Kubernets apiserver listening port.";
        default = 8080;
        type = types.int;
      };

      readOnlyPort = mkOption {
        description = "Kubernets apiserver read-only port.";
        default = 7080;
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

      tokenAuth = mkOption {
        description = ''
          Kubernetes apiserver token authentication file. See
          <link xlink:href="https://github.com/GoogleCloudPlatform/kubernetes/blob/master/docs/authentication.md"/>
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
          <link xlink:href="https://github.com/GoogleCloudPlatform/kubernetes/blob/master/docs/authorization.md"/>
        '';
        default = "AlwaysAllow";
        type = types.enum ["AlwaysAllow" "AlwaysDeny" "ABAC"];
      };

      authorizationPolicy = mkOption {
        description = ''
          Kubernetes apiserver authorization policy file. See
          <link xlink:href="https://github.com/GoogleCloudPlatform/kubernetes/blob/master/docs/authorization.md"/>
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
        description = "Kubernets scheduler listening port.";
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
        description = "Kubernets controller manager listening port.";
        default = 10252;
        type = types.int;
      };

      master = mkOption {
        description = "Kubernetes apiserver address";
        default = "${cfg.apiserver.address}:${toString cfg.apiserver.port}";
        type = types.str;
      };

      machines = mkOption {
        description = "Kubernetes apiserver list of machines to schedule to schedule onto";
        default = [];
        type = types.listOf types.str;
      };

      extraOpts = mkOption {
        description = "Kubernetes scheduler extra command line options.";
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

      address = mkOption {
        description = "Kubernetes kubelet info server listening address.";
        default = "0.0.0.0";
        type = types.str;
      };

      port = mkOption {
        description = "Kubernets kubelet info server listening port.";
        default = 10250;
        type = types.int;
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

      extraOpts = mkOption {
        description = "Kubernetes proxy extra command line options.";
        default = "";
        type = types.str;
      };
    };
  };

  ###### implementation

  config = mkMerge [
    (mkIf cfg.apiserver.enable {
      systemd.services.kubernetes-apiserver = {
        description = "Kubernetes Api Server";
        wantedBy = [ "multi-user.target" ];
        after = [ "network-interfaces.target" "etcd.service" ];
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
            -etcd_servers=${concatMapStringsSep "," (f: "http://${f}") cfg.etcdServers} \
            -address=${cfg.apiserver.address} \
            -port=${toString cfg.apiserver.port} \
            -read_only_port=${toString cfg.apiserver.readOnlyPort} \
            -public_address_override=${cfg.apiserver.publicAddress} \
            -allow_privileged=${if cfg.apiserver.allowPrivileged then "true" else "false"} \
            ${optionalString (cfg.apiserver.tlsCertFile!="")
              "-tls_cert_file=${cfg.apiserver.tlsCertFile}"} \
            ${optionalString (cfg.apiserver.tlsPrivateKeyFile!="")
              "-tls_private_key_file=${cfg.apiserver.tlsPrivateKeyFile}"} \
            ${optionalString (cfg.apiserver.tokenAuth!=[])
              "-token_auth_file=${tokenAuthFile}"} \
            -authorization_mode=${cfg.apiserver.authorizationMode} \
            ${optionalString (cfg.apiserver.authorizationMode == "ABAC")
              "-authorization_policy_file=${authorizationPolicyFile}"} \
            ${optionalString (cfg.apiserver.tlsCertFile!="" && cfg.apiserver.tlsCertFile!="")
              "-secure_port=${toString cfg.apiserver.securePort}"} \
            -portal_net=${cfg.apiserver.portalNet} \
            -logtostderr=true \
            ${optionalString cfg.verbose "-v=6 -log_flush_frequency=1s"} \
            ${cfg.apiserver.extraOpts}
          '';
          User = "kubernetes";
        };
        postStart = ''
          until ${pkgs.curl}/bin/curl -s -o /dev/null 'http://${cfg.apiserver.address}:${toString cfg.apiserver.port}/'; do
            sleep 1;
          done
        '';
      };
    })

    (mkIf cfg.scheduler.enable {
      systemd.services.kubernetes-scheduler = {
        description = "Kubernetes Scheduler Service";
        wantedBy = [ "multi-user.target" ];
        after = [ "network-interfaces.target" "kubernetes-apiserver.service" ];
        serviceConfig = {
          ExecStart = ''${cfg.package}/bin/kube-scheduler \
            -address=${cfg.scheduler.address} \
            -port=${toString cfg.scheduler.port} \
            -master=${cfg.scheduler.master} \
            -logtostderr=true \
            ${optionalString cfg.verbose "-v=6 -log_flush_frequency=1s"} \
            ${cfg.scheduler.extraOpts}
          '';
          User = "kubernetes";
        };
      };
    })

    (mkIf cfg.controllerManager.enable {
      systemd.services.kubernetes-controller-manager = {
        description = "Kubernetes Controller Manager Service";
        wantedBy = [ "multi-user.target" ];
        after = [ "network-interfaces.target" "kubernetes-apiserver.service" ];
        serviceConfig = {
          ExecStart = ''${cfg.package}/bin/kube-controller-manager \
            -address=${cfg.controllerManager.address} \
            -port=${toString cfg.controllerManager.port} \
            -master=${cfg.controllerManager.master} \
            ${optionalString (cfg.controllerManager.machines != [])
                "-machines=${concatStringsSep "," cfg.controllerManager.machines}"} \
            -logtostderr=true \
            ${optionalString cfg.verbose "-v=6 -log_flush_frequency=1s"} \
            ${cfg.controllerManager.extraOpts}
          '';
          User = "kubernetes";
        };
      };
    })

    (mkIf cfg.kubelet.enable {
      systemd.services.kubernetes-kubelet = {
        description = "Kubernetes Kubelet Service";
        wantedBy = [ "multi-user.target" ];
        after = [ "network-interfaces.target" "etcd.service" "docker.service" ];
        serviceConfig = {
          ExecStart = ''${cfg.package}/bin/kubelet \
            -etcd_servers=${concatMapStringsSep "," (f: "http://${f}") cfg.etcdServers} \
            -address=${cfg.kubelet.address} \
            -port=${toString cfg.kubelet.port} \
            -hostname_override=${cfg.kubelet.hostname} \
            -allow_privileged=${if cfg.kubelet.allowPrivileged then "true" else "false"} \
            -root_dir=${cfg.dataDir} \
            -logtostderr=true \
            ${optionalString cfg.verbose "-v=6 -log_flush_frequency=1s"} \
            ${cfg.kubelet.extraOpts}
          '';
          User = "kubernetes";
          PermissionsStartOnly = true;
          WorkingDirectory = cfg.dataDir;
        };
      };
    })

    (mkIf cfg.proxy.enable {
      systemd.services.kubernetes-proxy = {
        description = "Kubernetes Proxy Service";
        wantedBy = [ "multi-user.target" ];
        after = [ "network-interfaces.target" "etcd.service" ];
        serviceConfig = {
          ExecStart = ''${cfg.package}/bin/kube-proxy \
            -etcd_servers=${concatMapStringsSep "," (s: "http://${s}") cfg.etcdServers} \
            -bind_address=${cfg.proxy.address} \
            -logtostderr=true \
            ${optionalString cfg.verbose "-v=6 -log_flush_frequency=1s"} \
            ${cfg.proxy.extraOpts}
          '';
        };
      };
    })

    (mkIf (any (el: el == "master") cfg.roles) {
      virtualisation.kubernetes.apiserver.enable = mkDefault true;
      virtualisation.kubernetes.scheduler.enable = mkDefault true;
      virtualisation.kubernetes.controllerManager.enable = mkDefault true;
    })

    (mkIf (any (el: el == "node") cfg.roles) {
      virtualisation.docker.enable = mkDefault true;
      virtualisation.kubernetes.kubelet.enable = mkDefault true;
      virtualisation.kubernetes.proxy.enable = mkDefault true;
    })

    (mkIf (any (el: el == "node" || el == "master") cfg.roles) {
      services.etcd.enable = mkDefault true;
    })

    (mkIf (
        cfg.apiserver.enable ||
        cfg.scheduler.enable ||
        cfg.controllerManager.enable ||
        cfg.kubelet.enable ||
        cfg.proxy.enable
    ) {
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
