{
  config,
  lib,
  pkgs,
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
    iso = [ ../installer/cd-dvd/iso-image.nix ];
    iso-installer = [ ../installer/cd-dvd/installation-cd-base.nix ];
    sd-card = [
      (
        let
          module = ../. + "/installer/sd-card/sd-image-${pkgs.targetPlatform.linuxArch}.nix";
        in
        if builtins.pathExists module then module else throw "The module ${module} does not exist."
      )
    ];
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
