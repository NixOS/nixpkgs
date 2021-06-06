{ config, lib, pkgs, utils, ... }:
let
  cfg = config.virtualisation.containers;

  inherit (lib) mkOption types;

  toml = pkgs.formats.toml { };
in
{
  meta = {
    maintainers = [] ++ lib.teams.podman.members;
  };


  imports = [
    (
      lib.mkRemovedOptionModule
      [ "virtualisation" "containers" "users" ]
      "All users with `isNormalUser = true` set now get appropriate subuid/subgid mappings."
    )
    (
      lib.mkRemovedOptionModule
      [ "virtualisation" "containers" "containersConf" "extraConfig" ]
      "Use virtualisation.containers.containersConf.settings instead."
    )
  ];

  options.virtualisation.containers = {

    enable =
      mkOption {
        type = types.bool;
        default = false;
        description = ''
          This option enables the common /etc/containers configuration module.
        '';
      };

    ociSeccompBpfHook.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable the OCI seccomp BPF hook";
    };

    containersConf.settings = mkOption {
      type = toml.type;
      default = { };
      description = "containers.conf configuration";
    };

    containersConf.cniPlugins = mkOption {
      type = types.listOf types.package;
      defaultText = ''
        [
          pkgs.cni-plugins
        ]
      '';
      example = lib.literalExample ''
        [
          pkgs.cniPlugins.dnsname
        ]
      '';
      description = ''
        CNI plugins to install on the system.
      '';
    };

    storage.settings = mkOption {
      type = toml.type;
      default = {
        storage = {
          driver = "overlay";
          graphroot = "/var/lib/containers/storage";
          runroot = "/run/containers/storage";
        };
      };
      description = "storage.conf configuration";
    };

    registries = {
      search = mkOption {
        type = types.listOf types.str;
        default = [ "docker.io" "quay.io" ];
        description = ''
          List of repositories to search.
        '';
      };

      insecure = mkOption {
        default = [];
        type = types.listOf types.str;
        description = ''
          List of insecure repositories.
        '';
      };

      block = mkOption {
        default = [];
        type = types.listOf types.str;
        description = ''
          List of blocked repositories.
        '';
      };
    };

    policy = mkOption {
      default = {};
      type = types.attrs;
      example = lib.literalExample ''
        {
          default = [ { type = "insecureAcceptAnything"; } ];
          transports = {
            docker-daemon = {
              "" = [ { type = "insecureAcceptAnything"; } ];
            };
          };
        }
      '';
      description = ''
        Signature verification policy file.
        If this option is empty the default policy file from
        <literal>skopeo</literal> will be used.
      '';
    };

  };

  config = lib.mkIf cfg.enable {

    virtualisation.containers.containersConf.cniPlugins = [ pkgs.cni-plugins ];

    virtualisation.containers.containersConf.settings = {
      network.cni_plugin_dirs = map (p: "${lib.getBin p}/bin") cfg.containersConf.cniPlugins;
      engine = {
        init_path = "${pkgs.catatonit}/bin/catatonit";
      } // lib.optionalAttrs cfg.ociSeccompBpfHook.enable {
        hooks_dir = [ config.boot.kernelPackages.oci-seccomp-bpf-hook ];
      };
    };

    environment.etc."containers/containers.conf".source =
      toml.generate "containers.conf" cfg.containersConf.settings;

    environment.etc."containers/storage.conf".source =
      toml.generate "storage.conf" cfg.storage.settings;

    environment.etc."containers/registries.conf".source = toml.generate "registries.conf" {
      registries = lib.mapAttrs (n: v: { registries = v; }) cfg.registries;
    };

    environment.etc."containers/policy.json".source =
      if cfg.policy != {} then pkgs.writeText "policy.json" (builtins.toJSON cfg.policy)
      else utils.copyFile "${pkgs.skopeo.src}/default-policy.json";
  };

}
