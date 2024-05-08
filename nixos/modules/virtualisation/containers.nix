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
      description = ''
        CNI plugins to install on the system.
      '';
    };

    storage.settings = mkOption {
      type = toml.type;
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
        default = [ ];
        type = types.listOf types.str;
        description = ''
          List of insecure repositories.
        '';
      };

      block = mkOption {
        default = [ ];
        type = types.listOf types.str;
        description = ''
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
      description = ''
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

    virtualisation.containers.storage.settings.storage = {
      driver = lib.mkDefault "overlay";
      graphroot = lib.mkDefault "/var/lib/containers/storage";
      runroot = lib.mkDefault "/run/containers/storage";
    };

    environment.etc = {
      "containers/containers.conf".source =
        toml.generate "containers.conf" cfg.containersConf.settings;

      "containers/storage.conf".source =
        toml.generate "storage.conf" cfg.storage.settings;

      "containers/registries.conf".source = toml.generate "registries.conf" {
        registries = lib.mapAttrs (n: v: { registries = v; }) cfg.registries;
      };

      "containers/policy.json".source =
        if cfg.policy != { } then pkgs.writeText "policy.json" (builtins.toJSON cfg.policy)
        else "${pkgs.skopeo.policy}/default-policy.json";
    };

  };

}
