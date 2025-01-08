{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.virtualisation.containers;

  inherit (lib) literalExpression lib.mkOption types;

  toml = pkgs.formats.toml { };
in
{
  meta = {
    maintainers = [ ] ++ lib.teams.podman.members;
  };

  options.virtualisation.containers = {

    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        This option enables the common /etc/containers configuration module.
      '';
    };

    ociSeccompBpfHook.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable the OCI seccomp BPF hook";
    };

    containersConf.settings = lib.mkOption {
      type = toml.type;
      default = { };
      description = "containers.conf configuration";
    };

    containersConf.cniPlugins = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      defaultText = lib.literalExpression ''
        [
          pkgs.cni-plugins
        ]
      '';
      example = lib.literalExpression ''
        [
          pkgs.cniPlugins.dnsname
        ]
      '';
      description = ''
        CNI plugins to install on the system.
      '';
    };

    storage.settings = lib.mkOption {
      type = toml.type;
      description = "storage.conf configuration";
    };

    registries = {
      search = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          "docker.io"
          "quay.io"
        ];
        description = ''
          List of repositories to search.
        '';
      };

      insecure = lib.mkOption {
        default = [ ];
        type = lib.types.listOf lib.types.str;
        description = ''
          List of insecure repositories.
        '';
      };

      block = lib.mkOption {
        default = [ ];
        type = lib.types.listOf lib.types.str;
        description = ''
          List of blocked repositories.
        '';
      };
    };

    policy = lib.mkOption {
      default = { };
      type = lib.types.attrs;
      example = lib.literalExpression ''
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
      engine =
        {
          init_path = "${pkgs.catatonit}/bin/catatonit";
        }
        // lib.optionalAttrs cfg.ociSeccompBpfHook.enable {
          hooks_dir = [ config.boot.kernelPackages.oci-seccomp-bpf-hook ];
        };
    };

    virtualisation.containers.storage.settings.storage = {
      driver = lib.mkDefault "overlay";
      graphroot = lib.mkDefault "/var/lib/containers/storage";
      runroot = lib.mkDefault "/run/containers/storage";
    };

    environment.etc = {
      "containers/containers.conf".source = toml.generate "containers.conf" cfg.containersConf.settings;

      "containers/storage.conf".source = toml.generate "storage.conf" cfg.storage.settings;

      "containers/registries.conf".source = toml.generate "registries.conf" {
        registries = lib.mapAttrs (n: v: { registries = v; }) cfg.registries;
      };

      "containers/policy.json".source =
        if cfg.policy != { } then
          pkgs.writeText "policy.json" (builtins.toJSON cfg.policy)
        else
          "${pkgs.skopeo.policy}/default-policy.json";
    };

  };

}
