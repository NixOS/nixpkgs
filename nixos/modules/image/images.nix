{
  config,
  lib,
  pkgs,
  extendModules,
  ...
}:
let
  inherit (lib) types;

  imageModules = {
    azure = [ ../virtualisation/azure-image.nix ];
    digital-ocean = [ ../virtualisation/digital-ocean-image.nix ];
    google-compute = [ ../virtualisation/google-compute-image.nix ];
    hyperv = [ ../virtualisation/hyperv-image.nix ];
    linode = [ ../virtualisation/linode-image.nix ];
    lxc = [ ../virtualisation/lxc-container.nix ];
    lxc-metadata = [ ../virtualisation/lxc-image-metadata.nix ];
    oci = [ ../virtualisation/oci-image.nix ];
    proxmox = [ ../virtualisation/proxmox-image.nix ];
    kubevirt = [ ../virtualisation/kubevirt.nix ];
    vagrant-virtualbox = [ ../virtualisation/vagrant-virtualbox-image.nix ];
    virtualbox = [ ../virtualisation/virtualbox-image.nix ];
    vmware = [ ../virtualisation/vmware-image.nix ];
  };
  imageConfigs = lib.mapAttrs (
    name: modules:
    extendModules {
      inherit modules;
    }
  ) config.image.modules;
in
{
  options = {
    system.build = {
      images = lib.mkOption {
        type = types.lazyAttrsOf types.raw;
        readOnly = true;
        description = ''
          Different target images generated for this NixOS configuration.
        '';
      };
    };
    image.modules = lib.mkOption {
      type = types.attrsOf (types.listOf types.deferredModule);
      description = ''
        image-specific NixOS Modules used for `system.build.images`.
      '';
    };
  };

  config.image.modules = lib.mkIf (!config.system.build ? image) imageModules;
  config.system.build.images = lib.mkIf (!config.system.build ? image) (
    lib.mapAttrs (
      name: nixos:
      let
        inherit (nixos) config;
        inherit (config.image) filePath;
        builder =
          config.system.build.image
            or (throw "Module for `system.build.images.${name}` misses required `system.build.image` option.");
      in
      lib.recursiveUpdate builder {
        passthru = {
          inherit config filePath;
        };
      }
    ) imageConfigs
  );
}
