{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.programs.podman;

in

{
  ###### interface
  options = {
    programs.podman = {
      enable = mkOption {
        default = false;
        description = ''
          Whether to configure podman
        '';
        type = types.bool;
      };
      package = mkOption {
        default = pkgs.podman;
        description = "podman package to be used";
        type = types.package;
      };
      runcPackage = mkOption {
        default = pkgs.runc;
        description = "runc package to be used";
        type = types.package;
      };
      conmonPackage = mkOption {
        default = pkgs.conmon;
        description = "conmon package to be used";
        type = types.package;
      };
      cniPackage = mkOption {
        default = pkgs.cni;
        description = "cni package to be used";
        type = types.package;
      };
      cniPluginsPackage = mkOption {
        default = pkgs.cni-plugins;
        description = "cni-plugins package to be used";
        type = types.package;
      };
    };
  };

  ###### implementation
  config = mkIf cfg.enable {

    environment.etc."containers/libpod.conf".text = ''
      image_default_transport = "docker://"
      runtime_path = ["${cfg.runcPackage}/bin/runc"]
      conmon_path = ["${cfg.conmonPackage}/bin/conmon"]
      cni_plugin_dir = ["${cfg.cniPluginsPackage}/bin/"]
      cgroup_manager = "systemd"
      cni_config_dir = "/etc/cni/net.d/"
      cni_default_network = "podman"
      # pause
      pause_image = "k8s.gcr.io/pause:3.1"
      pause_command = "/pause"
    '';

    environment.etc."containers/registries.conf".text = ''
      [registries.search]
      registries = ['docker.io', 'registry.fedoraproject.org', 'quay.io', 'registry.access.redhat.com', 'registry.centos.org']
    '';

    environment.etc."containers/policy.json".text = ''
    {
      "default": [
        { "type": "insecureAcceptAnything" }
      ]
    }
    '';

    environment.etc."cni/net.d/87-podman-bridge.conflist".text = ''
{
    "cniVersion": "0.3.0",
    "name": "podman",
    "plugins": [
      {
        "type": "bridge",
        "bridge": "cni0",
        "isGateway": true,
        "ipMasq": true,
        "ipam": {
            "type": "host-local",
            "subnet": "10.88.0.0/16",
            "routes": [
                { "dst": "0.0.0.0/0" }
            ]
        }
      },
      {
        "type": "portmap",
        "capabilities": {
          "portMappings": true
        }
      }
    ]
}
    '';

    environment.systemPackages = with pkgs; [ cfg.package cfg.conmonPackage cfg.runcPackage ];

  };
}
