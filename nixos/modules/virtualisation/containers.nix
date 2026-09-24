{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.virtualisation.containers;

  inherit (lib) literalExpression mkOption types;

  toml = pkgs.formats.toml { };
  json = pkgs.formats.json { };
  mkOptions = file: {
    rootless.settings = mkOption {
      type = toml.type;
      default = { };
      description = "rootless ${file} configuration";
    };
    rootful.settings = mkOption {
      type = toml.type;
      default = { };
      description = "rootful ${file} configuration";
    };
    settings = mkOption {
      type = toml.type;
      default = { };
      description = "base ${file} configuration";
    };
  };
in
{
  meta = {
    teams = [ lib.teams.podman ];
  };
  imports = [
    (lib.mkRemovedOptionModule [
      "virtualisation"
      "containers"
      "containersConf"
      "cniPlugins"
    ] "Podman 6.0 removed support for CNI networking.")
    (lib.mkRemovedOptionModule
      [
        "virtualisation"
        "containers"
        "registries"
        "search"
      ]
      "Podman 6.0 dropped support for the deprecated V1 registry.conf format. Migrate to virtualisation.containers.registries.settings."
    )
    (lib.mkRemovedOptionModule
      [
        "virtualisation"
        "containers"
        "registries"
        "insecure"
      ]
      "Podman 6.0 dropped support for the deprecated V1 registry.conf format. Migrate to virtualisation.containers.registries.settings."
    )
    (lib.mkRemovedOptionModule
      [
        "virtualisation"
        "containers"
        "registries"
        "block"
      ]
      "Podman 6.0 dropped support for the deprecated V1 registry.conf format. Migrate to virtualisation.containers.registries.settings."
    )
  ];

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

    shortnames.enable = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Enable the usage of a collection of common aliases for fully qualified images.
        See https://github.com/containers/shortnames.
      '';
    };

    containersConf = mkOptions "containers.conf";
    storage = mkOptions "storage.conf";

    registries.settings = mkOption {
      type = toml.type;
      default = { };
      description = ''
        registries.conf configuration.

        Examine [containers-registries.conf(5)] for more information about the format.

          [containers-registries.conf(5)]: https://github.com/containers/image/blob/main/docs/containers-registries.conf.5.md
      '';
    };

    policy = mkOption {
      default = { };
      type = json.type;
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

  config =
    let
      dropIn =
        name: scope: settings:
        let
          path = "${name}${lib.optionalString (scope != "") ".${scope}"}.conf";
          filename = if scope == "" then "00-nixos.conf" else "10-nixos-${scope}.conf";
        in
        lib.optionalAttrs (settings != { }) {
          "containers/${path}.d/${filename}".source = toml.generate path settings;
        };
    in
    lib.mkIf cfg.enable {
      assertions =
        let
          attr = name: default: lib.attrByPath [ "network" name ] default cfg.containersConf.settings;
        in
        [
          {
            assertion = (attr "default_rootless_network_cmd" "pasta") == "pasta";
            message = "Podman 6.0 only supports pasta for rootless networking.";
          }
          {
            assertion = (attr "firewall_driver" "nftables") != "iptables";
            message = "Podman 6.0 no longer supports iptables as a firewall driver. Use nftables instead.";
          }
          {
            assertion = (attr "network_backend" "netavark") == "netavark";
            message = "Podman 6.0 no longer supports network backends other than netavark.";
          }
        ];

      warnings =
        lib.optional (lib.hasAttrByPath [ "storage" "graphroot" ] cfg.storage.settings) ''
          virtualisation.containers.storage.settings.storage.graphroot now applies to both rootful and rootless podman and will likely not work as intended.
          Use virtualisation.containers.storage.{rootful,rootless}.settings.storage.graphroot instead.
        ''
        ++ lib.optional (lib.hasAttrByPath [ "storage" "runroot" ] cfg.storage.settings) ''
          virtualisation.containers.storage.settings.storage.runroot now applies to both rootful and rootless podman and will likely not work as intended.
          Use virtualisation.containers.storage.{rootful,rootless}.settings.storage.runroot instead.
        '';

      virtualisation.containers = {
        containersConf.settings = {
          engine = lib.mkIf cfg.ociSeccompBpfHook.enable {
            hooks_dir = [ config.boot.kernelPackages.oci-seccomp-bpf-hook ];
          };
          containers = {
            default_sysctls = lib.mkDefault [ "net.ipv4.ping_group_range=0 0" ];
          };
        };
        storage = {
          settings.storage = {
            driver = lib.mkDefault "overlay";
            options.overlay.mountopt = lib.mkDefault "nodev";
          };
        };
      };

      environment.etc = lib.mkMerge [
        (dropIn "containers" "" cfg.containersConf.settings)
        (dropIn "containers" "rootful" cfg.containersConf.rootful.settings)
        (dropIn "containers" "rootless" cfg.containersConf.rootless.settings)
        (dropIn "storage" "" cfg.storage.settings)
        (dropIn "storage" "rootful" cfg.storage.rootful.settings)
        (dropIn "storage" "rootless" cfg.storage.rootless.settings)
        (dropIn "registries" "" cfg.registries.settings)
        {
          "containers/policy.json".source =
            if cfg.policy != { } then
              json.generate "policy.json" cfg.policy
            else
              "${pkgs.skopeo.policy}/default-policy.json";
        }
        (lib.mkIf cfg.shortnames.enable {
          "containers/registries.conf.d/000-shortnames.conf".source = pkgs.containers-shortnames.shortnames;
        })
      ];
    };
}
