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
    amazon = ../../maintainers/scripts/ec2/amazon-image.nix;
    azure = ../virtualisation/azure-image.nix;
    cloudstack = ../../maintainers/scripts/cloudstack/cloudstack-image.nix;
    digital-ocean = ../virtualisation/digital-ocean-image.nix;
    google-compute = ../virtualisation/google-compute-image.nix;
    hyperv = ../virtualisation/hyperv-image.nix;
    linode = ../virtualisation/linode-image.nix;
    lxc = ../virtualisation/lxc-container.nix;
    lxc-metadata = ../virtualisation/lxc-image-metadata.nix;
    oci = ../virtualisation/oci-image.nix;
    openstack = ../../maintainers/scripts/openstack/openstack-image.nix;
    openstack-zfs = ../../maintainers/scripts/openstack/openstack-image-zfs.nix;
    proxmox = ../virtualisation/proxmox-image.nix;
    proxmox-lxc = ../virtualisation/proxmox-lxc.nix;
    qemu-efi = ../virtualisation/disk-image.nix;
    qemu = {
      imports = [ ../virtualisation/disk-image.nix ];
      image.efiSupport = false;
    };
    raw-efi = {
      imports = [ ../virtualisation/disk-image.nix ];
      image.format = "raw";
    };
    raw = {
      imports = [ ../virtualisation/disk-image.nix ];
      image.format = "raw";
      image.efiSupport = false;
    };
    kubevirt = ../virtualisation/kubevirt.nix;
    vagrant-virtualbox = ../virtualisation/vagrant-virtualbox-image.nix;
    virtualbox = ../virtualisation/virtualbox-image.nix;
    vmware = ../virtualisation/vmware-image.nix;
    iso = ../installer/cd-dvd/iso-image.nix;
    iso-installer = ../installer/cd-dvd/installation-cd-base.nix;
    sd-card = {
      imports =
        let
          module = ../. + "/installer/sd-card/sd-image-${pkgs.targetPlatform.qemuArch}.nix";
        in
        if builtins.pathExists module then
          [ module ]
        else
          throw "The module ${toString module} does not exist.";
    };
    kexec = ../installer/netboot/netboot-minimal.nix;
  };
  imageConfigs = lib.mapAttrs (
    name: module:
    extendModules {
      modules = [ module ];
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
      type = types.attrsOf types.deferredModule;
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
