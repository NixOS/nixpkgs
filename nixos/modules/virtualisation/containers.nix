{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.virtualisation.containers;

  inherit (lib) literalExpression mkOption types;

  oldRegistriesOptionsUsed = lib.any (x: x != [ ]) (
    with cfg.registries;
    [
      search
      insecure
      block
    ]
  );

  toml = pkgs.formats.toml { };
in
{
  meta = {
    maintainers = [ ] ++ lib.teams.podman.members;
  };

  options.virtualisation.containers = {

    enable = mkOption {
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
      # TODO: remove those options in 26.11
      search = mkOption {
        visible = false;
        type = types.listOf types.str;
        default = [ ];
        description = ''
          List of repositories to search.

          Deprecated, examine {option}`virtualisation.registries.settings` instead.
        '';
      };

      insecure = mkOption {
        default = [ ];
        visible = false;
        type = types.listOf types.str;
        description = ''
          List of insecure repositories.

          Deprecated, examine {option}`virtualisation.registries.settings` instead.
        '';
      };

      block = mkOption {
        default = [ ];
        visible = false;
        type = types.listOf types.str;
        description = ''
          List of blocked repositories.

          Deprecated, examine {option}`virtualisation.registries.settings` instead.
        '';
      };

      settings = mkOption {
        type = toml.type;
        default = {
          registry = [
            { location = "docker.io"; }
            { location = "quay.io"; }
          ];
        };
        description = ''
          repositories.conf configuration.

          Examine [containers-registries.conf(5)] for more information about the format.

            [containers-registries.conf(5)]: https://github.com/containers/image/blob/main/docs/containers-registries.conf.5.md
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
    warnings = lib.optional oldRegistriesOptionsUsed "the options virtualisation.registries.search / insecure / block are deprecated. See virtualisation.registries.settings instead.";

    virtualisation.containers.registries.settings = lib.mkIf oldRegistriesOptionsUsed {
      registries = {
        block.registries = cfg.registries.block;
        insecure.registries = cfg.registries.insecure;
        search.registries = cfg.registries.search;
      };
    };

    virtualisation.containers.containersConf.cniPlugins = [ pkgs.cni-plugins ];

    virtualisation.containers.containersConf.settings = {
      network.cni_plugin_dirs = map (p: "${lib.getBin p}/bin") cfg.containersConf.cniPlugins;
      engine = {
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

      "containers/registries.conf".source = toml.generate "registries.conf" cfg.registries.settings;

      "containers/policy.json".source =
        if cfg.policy != { } then
          pkgs.writeText "policy.json" (builtins.toJSON cfg.policy)
        else
          "${pkgs.skopeo.policy}/default-policy.json";
    };

  };

}
