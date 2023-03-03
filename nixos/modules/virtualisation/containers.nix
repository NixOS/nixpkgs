{ config, lib, pkgs, ... }:
let
  cfg = config.virtualisation.containers;

  inherit (lib) literalExpression mkOption types;

  toml = pkgs.formats.toml { };
in
{
  meta = {
    maintainers = [ ] ++ lib.teams.podman.members;
  };

  options.virtualisation.containers = {

    enable =
      mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          This option enables the common /etc/containers configuration module.
        '';
      };

    ociSeccompBpfHook.enable = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc "Enable the OCI seccomp BPF hook";
    };

    containersConf.settings = mkOption {
      type = toml.type;
      default = { };
      description = lib.mdDoc "containers.conf configuration";
    };

    containersConf.cniPlugins = mkOption {
      type = types.listOf types.package;
      defaultText = literalExpression ''
        [
          pkgs.cni-plugins
        ]
      '';
      example = literalExpression ''
        [
          pkgs.cniPlugins.dnsname
        ]
      '';
      description = lib.mdDoc ''
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
      description = lib.mdDoc "storage.conf configuration";
    };

    registries = {
      search = mkOption {
        type = types.listOf types.str;
        default = [ "docker.io" "quay.io" ];
        description = lib.mdDoc ''
          List of repositories to search.
        '';
      };

      insecure = mkOption {
        default = [ ];
        type = types.listOf types.str;
        description = lib.mdDoc ''
          List of insecure repositories.
        '';
      };

      block = mkOption {
        default = [ ];
        type = types.listOf types.str;
        description = lib.mdDoc ''
          List of blocked repositories.
        '';
      };
    };

    policy = mkOption {
      default = { };
      type = types.attrs;
      example = literalExpression ''
        {
          default = [ { type = "insecureAcceptAnything"; } ];
          transports = {
            docker-daemon = {
              "" = [ { type = "insecureAcceptAnything"; } ];
            };
          };
        }
      '';
      description = lib.mdDoc ''
        Signature verification policy file.
        If this option is empty the default policy file from
        `skopeo` will be used.
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
      if cfg.policy != { } then pkgs.writeText "policy.json" (builtins.toJSON cfg.policy)
      else "${pkgs.skopeo.policy}/default-policy.json";
  };

}
