{
  config,
  lib,
  extendModules,
  ...
}:
let
  inherit (lib)
    types
    ;

  imageModules = {
    amazon = [ ../../maintainers/scripts/ec2/amazon-image.nix ];
    azure = [ ./azure-image.nix ];
    digital-ocean = [ ./digital-ocean-image.nix ];
    google-compute = [ ./google-compute-image.nix ];
    hyperv = [ ./hyperv-image.nix ];
    linode = [ ./linode-image.nix ];
    oci = [ ./oci-image.nix ];
    proxmox = [ ./proxmox-image.nix ];
    kube-virt = [ ./kubevirt.nix ];
    vagrant-virtualbox = [ ./vagrant-virtualbox-image.nix ];
    virtualbox = [ ./virtualbox-image.nix ];
    vmware = [ ./vmware-image.nix ];
  };
  imageConfigs = lib.mapAttrs (
    name: modules:
    extendModules {
      inherit modules;
    }
  ) config.system.build.imageModules;
in
{
  options.system.build = {
    images = lib.mkOption {
      type = types.lazyAttrsOf types.raw;
      description = ''
        Different target images generated for this NixOS configuration.
      '';
    };
    imageModules = lib.mkOption {
      type = types.attrsOf (types.listOf types.deferredModule);
      description = ''
        Modules used for `system.build.images`.
      '';
    };
  };

  config.system.build = {
    inherit imageModules;
    images = lib.mapAttrs (
      name: conf:
      lib.recursiveUpdate conf.config.image.builder {
        passthru.config = conf.config;
      }
    ) imageConfigs;
  };
}
